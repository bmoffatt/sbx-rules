#!/usr/bin/env bash
# PreToolUse hook (matcher: Bash). Rejects a `gh` command that publishes text to
# GitHub unless the text carries the Claude banner (see rules/github-banner.md).
# Exit 2 blocks the call and sends stderr back to Claude.
set -u

BANNER='🤖 Generated with [Claude Code](https://claude.com/claude-code)'
MARKER='claude.com/claude-code'

cmd=$(jq -r '.tool_input.command // empty')
[ -n "$cmd" ] || exit 0

# `gh` as a command word: at the start, or after ; & | ( ` $(, so that
# `echo "gh pr create"` does not count.
gh='(^|[;&|(`]|\$\()[[:space:]]*gh[[:space:]]+'
body_flag='(^|[[:space:]])(--body|-b|--body-file|-F|--fill|--fill-first|--fill-verbose)([[:space:]=]|$)'

publishes=0 # the command posts text
needs_body=0 # a missing body is itself a problem (create/comment)
if [[ $cmd =~ ${gh}(pr|issue)[[:space:]]+(create|comment) ]]; then
  publishes=1
  needs_body=1
elif [[ $cmd =~ ${gh}(pr|issue)[[:space:]]+(review|edit) ]] && [[ $cmd =~ $body_flag ]]; then
  publishes=1
elif [[ $cmd =~ ${gh}api[[:space:]] ]] &&
  [[ $cmd =~ (-X|--method)[[:space:]=]+(POST|PATCH|PUT) ]] &&
  [[ $cmd =~ (comments|reviews|/pulls|/issues) ]]; then
  publishes=1
fi
[ "$publishes" = 1 ] || exit 0

# The text may be inline (--body, a heredoc, -f body=...) or in a file.
text="$cmd"
if [[ $cmd =~ (--body-file|-F)[[:space:]=]+([^[:space:]]+) ]]; then
  f="${BASH_REMATCH[2]//[\"\']/}"
  [ -f "$f" ] && text+=$'\n'"$(cat "$f")"
fi

case "$text" in *"$MARKER"*) exit 0 ;; esac

if [ "$needs_body" = 1 ] && ! [[ $cmd =~ $body_flag ]]; then
  echo "Blocked: pass the text with --body or --body-file so it can end with the banner: $BANNER" >&2
else
  echo "Blocked: GitHub posts must end with the Claude banner. Add this as the last line of the body, then re-run: $BANNER" >&2
fi
exit 2
