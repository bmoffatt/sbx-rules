# sbx-rules

An [sbx](https://docs.docker.com/ai/sandboxes/) (Docker Sandboxes) mixin kit that installs Claude rules into `~/.claude/rules/` in the sandbox.

| Rule | What it does |
| --- | --- |
| `collaborative-editing` | Re-read files before editing and prefer small targeted edits, since the user or other agents may be editing the same files concurrently. |

It is a [v3 kit](https://github.com/docker/sandbox-kit-spec) (`sbx-rules.yaml` plus `sbx-rules.dockerfile`), so it composes with the v3 `claude` kit and with [`sbx-statusline`](https://github.com/bmoffatt/sbx-statusline), but **not** with v1/v2 kits: sbx rejects a sandbox that mixes the two formats. Use the v3 build of any other kit you add alongside it.

## Use

From the project directory:

```sh
sbx run claude --kit docker.io/bmoffatt/sbx-rules:latest --name my-project
```

`docker.io/` is on sbx's default kit allowlist, so no setup is needed. `--kit` can be repeated to combine kits. Later attaches are just:

```sh
sbx run my-project
```

Every push to `main` republishes `:latest` to [Docker Hub](https://hub.docker.com/r/bmoffatt/sbx-rules), along with a tag for the `version:` in `sbx-rules.yaml` (see `.github/workflows/publish.yml`). Bump `version:` when the kit changes.

### From a local checkout

sbx builds a kit directory on demand, so there is no registry or push step while iterating:

```sh
sbx run claude --kit . --name my-project
```

### From git instead

sbx only installs kits from allowlisted sources. Allow this account's GitHub repos too (this replaces the list, so keep `docker.io/`):

```sh
sbx settings set kit.allowedSources '["docker.io/","github.com/bmoffatt/"]'
sbx run claude --kit 'git+https://github.com/bmoffatt/sbx-rules' --name my-project
```

## Caveat

`--kit` only applies when the sandbox is created. To add this kit to an existing sandbox, remove it and recreate it:

```sh
sbx rm my-project
sbx run claude --kit docker.io/bmoffatt/sbx-rules:latest --name my-project
```
