# Cursor Skills

A collection of [Cursor](https://cursor.com) Agent Skills. Skills are Markdown files that teach the Cursor agent how to perform specialized workflows.

## Skills

| Skill | Description |
| --- | --- |
| [`reading-papers`](skills/reading-papers/) | Critically read and analyze an academic paper across six dimensions (motivation, problem, method/novelty, related work, citation potential, future work) and produce a structured bilingual reading note. |

## Installation

Skills are loaded from `~/.cursor/skills/` (personal) or `.cursor/skills/` (per project).

### Install a single skill

```bash
git clone https://github.com/<your-username>/cursor-skills.git
cp -r cursor-skills/skills/reading-papers ~/.cursor/skills/
```

### Install all skills

```bash
git clone https://github.com/<your-username>/cursor-skills.git
cp -r cursor-skills/skills/* ~/.cursor/skills/
```

After installing, restart Cursor (or reload the window) so the agent picks up the new skills.

## Usage

Once installed, just ask the agent naturally — for example: "帮我精读这篇论文 <link>". The agent will auto-invoke the relevant skill based on its description.

## Repository Layout

```
cursor-skills/
├── README.md
├── LICENSE
└── skills/
    └── <skill-name>/
        └── SKILL.md
```

## Adding a New Skill

1. Create a folder `skills/<skill-name>/`.
2. Add a `SKILL.md` with YAML frontmatter (`name`, `description`).
3. Add the skill to the table above.

## License

[MIT](LICENSE)
