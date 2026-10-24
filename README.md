# sbx-rules

An [sbx](https://docs.docker.com/ai/sandboxes/) (Docker Sandboxes) mixin kit that installs Claude rules into `~/.claude/rules/` in the sandbox.

| Rule | What it does |
| --- | --- |
| `collaborative-editing` | Re-read files before editing and prefer small targeted edits, since the user or other agents may be editing the same files concurrently. |

## Setup (once)

sbx only installs kits from allowlisted sources, and the default is `docker.io/`. Allow this account's GitHub repos too:

```sh
sbx settings set kit.allowedSources '["docker.io/","github.com/bmoffatt/"]'
```

This replaces the list rather than appending to it, so keep `docker.io/` in it.

## Use

From the project directory:

```sh
sbx run claude --kit 'git+https://github.com/bmoffatt/sbx-rules' --name my-project
```

`--kit` can be repeated to combine kits. Later attaches are just:

```sh
sbx run my-project
```

## Caveat

`--kit` only applies when the sandbox is created. To add this kit to an existing sandbox, remove it and recreate it:

```sh
sbx rm my-project
sbx run claude --kit 'git+https://github.com/bmoffatt/sbx-rules' --name my-project
```
