## Collaborative Editing

Files here may be edited concurrently — by the user directly (doing fixups in parallel rather than prompting first), or by other agents/sessions working alongside you. Treat any file's content as potentially stale the moment it leaves your context; never assume the copy you last saw is still current.

- Before every Edit or Write, re-Read the file fresh if there's any chance it changed since your last Read in this conversation — a new turn, elapsed time, or any sign someone else touched it. Don't reuse a remembered `old_string` from an earlier turn without confirming it still matches what's on disk now.
- If an Edit fails because `old_string` doesn't match, that's a signal someone else changed the file — don't force it with a blind retry or fall back to a full Write that clobbers everything. Re-read, see what changed, and fold your intended change in on top of it.
- Once a file has real content, prefer small targeted Edits over full-file Write rewrites — a Write replaces the entire file and is the easiest way to silently destroy someone else's concurrent fixup.
- If content changed from what you last saw and you can't tell why, say so before proceeding. Don't assume it was a mistake and revert it — incorporate it.
