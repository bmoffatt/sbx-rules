# syntax=docker/dockerfile:1
# An overlay carrying the files/home/ tree (the rules under ~/.claude/rules/ and
# the hooks under ~/.claude/hooks/) onto /home/agent/, path for path.
#
# Staging stage: copying straight into a scratch stage with
# `COPY --chown=1000:1000 files/home/ /home/agent/` would make BuildKit chown
# every parent directory it creates, shipping `/home` itself owned by uid 1000,
# and an overlay's directory entries replace the base's. Staging under /out and
# chowning only /out/home/agent leaves /home root-owned and gives the agent
# exactly its own subtree. Same shape as the sbx-statusline kit.
#
# Pinned to $BUILDPLATFORM: it only copies and chowns text files, so it has no
# reason to run under emulation when the kit is published for both
# linux/amd64 and linux/arm64.
#
# 1000 rather than `agent`: busybox has no passwd entry for the agent user.
FROM --platform=$BUILDPLATFORM busybox:1.37 AS stage

COPY files/home/ /out/home/agent/
# The hooks run directly from settings.json, so they need the exec bit; the
# rules do not.
RUN chown -R 1000:1000 /out/home/agent && chmod 0755 /out/home/agent/.claude/hooks/*.sh

FROM scratch
COPY --from=stage /out /
