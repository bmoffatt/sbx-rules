## GitHub Banner

Anything you publish to GitHub on the user's behalf ends with this banner as its last line, so readers can tell it was written by an agent:

```
🤖 Generated with [Claude Code](https://claude.com/claude-code)
```

- Applies to PR descriptions, PR and issue comments, review bodies, and issue bodies, however they are sent (`gh`, `gh api`, an MCP tool).
- Put it on its own line at the end of the body, after a blank line. Don't paraphrase it, and don't add it to commit messages (git attribution already covers those).
- Reviews with no body (`gh pr review --approve` on its own) have nothing to attach it to; leave them as they are.
- A `PreToolUse` hook rejects `gh` commands that publish a body without the banner. If it fires, add the banner and re-run the command; don't work around the hook.
