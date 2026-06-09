---
name: reading-papers
description: Critically read and analyze an academic paper across six dimensions (motivation, problem, method/novelty, related work, citation/seed potential, future work) and produce a structured bilingual reading note saved as Markdown. Use when the user asks to read, analyze, critique, or take notes on a paper, PDF, or arXiv link.
---

# Reading Papers (论文精读)

Produce a rigorous, critical reading note for one paper. The goal is not to summarize — it is to **evaluate**. Always look for weaknesses, hidden assumptions, and "smells" (异味), not just merits.

## Output Conventions

- **Language**: 中英双语。正文用简体中文叙述，关键术语 / 方法名 / 指标保留英文（如 attention、ablation、SOTA）。
- **Format**: 结构化 Markdown 阅读笔记，保存为文件。
- **Filename**: `<short-paper-id>-notes.md`（如 `transformer-notes.md`）。若用户在 paper-reading 仓库中，保存到当前目录；否则保存到工作目录并告知路径。
- **Tone**: 批判性、有判断力。每个判断都要给出理由，避免复述摘要。

## Workflow

1. **获取论文内容**：读取用户提供的 PDF / 链接 / 文本。若只有标题或 arXiv ID，先用可用工具获取正文或摘要。
2. **逐维度分析**：按下面六个维度填写模板，每个维度都要下明确结论（如「motivation 成立 / 有异味」）。
3. **保存笔记**：写入 Markdown 文件，文件头包含标题、作者、年份、出处、链接。
4. **给出总评**：在对话中用 2-3 句话给出整体判断（是否值得深读、最大亮点、最大隐患）。

## Six Dimensions (六个核心维度)

逐条评估，每条都要有结论 + 理由，不要只描述论文怎么说。

1. **Motivation（动机）**
   - 论文的 motivation 是什么？
   - 是否站得住脚？逻辑链是否完整？
   - **是否有「异味」**：是否为了创新而创新？是否夸大痛点？是否回避了更简单的替代方案？

2. **Problem（问题）**
   - 论文要解决的核心问题是什么？
   - 这个问题是否**广泛存在 / 被社区讨论**？还是小众/人造问题？
   - 问题是否**重要**？解决它的价值有多大？

3. **Method & Core Novelty（方法与核心创新）**
   - 方法的关键步骤 / 架构。
   - **真正的创新点是什么**（与已有工作的 delta）？区分「真创新」与「换皮/组合」。
   - 方法是否能支撑 motivation 与 problem？

4. **Related Work（相关工作）**
   - 关键的相关工作有哪些（尤其是最直接的 baseline / 前驱工作）？
   - 本文相对它们的定位与区别。
   - 是否有**该引而未引**的重要工作？

5. **Citation / Seed Potential（高引/种子论文潜力）**
   - 是否具备成为高引或 seed 论文的潜质？
   - 判断依据：问题普适性、方法可迁移性、是否开辟新方向、复现成本、开源/数据可得性、timing。

6. **Future Work & Improvements（改进空间与未来工作）**
   - 论文的局限性（方法、实验、假设、泛化性）。
   - 还有哪些可做的未来工作 / 改进方向？
   - 哪些是「跟进性小改」，哪些是「值得自己做的研究机会」？

## Note Template

保存的 Markdown 使用以下结构：

```markdown
# <Paper Title>

- **Authors / Year / Venue**:
- **Link**:
- **One-line summary（一句话概括）**:

## 1. Motivation（动机）
- 动机：
- 是否成立 / 是否有异味（理由）：

## 2. Problem（问题）
- 核心问题：
- 普适性 & 重要性（理由）：

## 3. Method & Core Novelty（方法与创新）
- 方法概述：
- 核心创新点（vs 已有工作的 delta）：

## 4. Related Work（相关工作）
- 关键相关工作：
- 本文定位与区别：
- 缺失的重要引用（如有）：

## 5. Citation / Seed Potential（高引潜力）
- 判断：
- 依据：

## 6. Future Work & Improvements（改进空间）
- 局限性：
- 可做的未来工作 / 研究机会：

## Overall Verdict（总评）
- 是否值得深读：
- 最大亮点 / 最大隐患：
```

## Guidance

- **下结论**：每个维度结尾必须有一句明确判断，而不是只罗列论文内容。
- **找异味**：主动质疑 motivation 与实验设置（cherry-picked baseline、不公平对比、缺失 ablation、过强假设）。
- **区分创新真伪**：警惕「把 A 套到 B 上」「换数据集刷分」「重命名已有概念」这类伪创新。
- **诚实标注不确定**：若信息不足（如没读到实验细节），明确写出「未知 / 需补充」，不要臆造。
