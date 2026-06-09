# Research Skills

A collection of portable, research-focused [Agent Skills](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview) (paper reading & more) — Markdown files that teach an AI coding agent how to perform specialized research workflows.

Each skill uses only the cross-agent standard (`SKILL.md` with `name` + `description` frontmatter and plain Markdown), so the **same skill works in [Cursor](https://cursor.com), [Claude Code](https://www.claude.com/product/claude-code), and beyond** (Codex CLI, Gemini CLI, Copilot, …). Agent-specific frontmatter is intentionally avoided so nothing gets ignored or breaks.

## Skills

| Skill | Description |
| --- | --- |
| [`reading-papers`](skills/reading-papers/) | Critically read and analyze an academic paper across six dimensions (motivation, problem, method/novelty, related work, citation potential, future work) and produce a structured bilingual reading note. |

## Installation

A skill is just a directory containing `SKILL.md`. Agents discover skills from their own skills folder:

| Agent | Personal (all projects) | Project (per repo) |
| --- | --- | --- |
| Cursor | `~/.cursor/skills/` | `.cursor/skills/` |
| Claude Code | `~/.claude/skills/` | `.claude/skills/` |
| Other agents | `~/.<agent>/skills/` | `.<agent>/skills/` |

### Option A — one-click installer (recommended)

```bash
git clone https://github.com/fangz-cs/research-skills.git
cd research-skills
./install.sh                 # install all skills into every detected agent
./install.sh claude          # install all skills into Claude Code only
./install.sh cursor reading-papers   # install one skill into Cursor only
```

Usage: `./install.sh [cursor|claude|all] [<skill-name>|all]` (both args default to `all`).

### Option B — manual copy

```bash
git clone https://github.com/fangz-cs/research-skills.git
# Cursor
cp -r research-skills/skills/reading-papers ~/.cursor/skills/
# Claude Code
cp -r research-skills/skills/reading-papers ~/.claude/skills/
```

After installing, restart (or reload) your agent so it picks up the new skill.

## Usage

Once installed, just ask the agent naturally — for example: "帮我精读这篇论文 <link>". The agent auto-invokes the relevant skill based on its `description`.

## Repository Layout

```
.
├── README.md
├── LICENSE
├── install.sh
└── skills/
    └── <skill-name>/
        └── SKILL.md
```

## Adding a New Skill

1. Create a folder `skills/<skill-name>/` (the folder name must match the `name` in frontmatter).
2. Add `SKILL.md` with YAML frontmatter (`name`, `description`) and Markdown instructions.
3. For portability, stick to `name` + `description` + plain Markdown; keep `SKILL.md` under ~500 lines and move long reference material into sibling files.
4. Add the skill to the table above.

## License

[MIT](LICENSE)
