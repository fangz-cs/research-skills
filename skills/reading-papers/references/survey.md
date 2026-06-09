# Survey Mode (系统性文献调研)

主流程在 `SKILL.md`。本文件在用户给出一个**调研目标**(而非单篇论文)时读取,触发语如"系统调研 X / survey X / 调研一下如何把 A 用到 B"。

目标:围绕一个研究问题,**自主拆解需要调研的方向 → 有界地检索与精读 → 实时汇报 → 在关键节点回来与用户确认 → 最终给出落地建议**。绝不陷入无限循环烧时间和 token。

复用主流程:每篇值得深读的论文仍走 `SKILL.md` 的精读流程(front-matter + 六维度),综述仍走 `references/synthesis.md`。Survey Mode 是它们之上的**编排层**。

---

## 核心:一个带闸门和预算的状态机

```
Phase 0  Scope 拆解 → 产出研究计划 ──▶ 【闸门1:必停,等用户确认方向与预算】
Phase 1  逐方向:检索 → triage → 精读承重论文 → 汇报   (方向边界处有条件闸门)
Phase 2  综合 → 生成 landscape + 落地建议 ──▶ 【最终闸门:呈现并确认】
```

**自主 vs 受控的平衡**:方向拆解、检索、判断哪篇承重——这些 Claude 自主做;但**扩大范围、超预算、目标可能要调整**这三类决定必须回来问用户。问在该问的地方,而不是每步都打扰。

---

## Phase 0 — Scope 拆解(产出计划,然后必停)

从研究目标反推**需要哪些调研方向**,不要等用户列。每个方向给:名称、为什么需要它、初步检索词、预算。

拆解要点:**主动补上用户没点名但显然必要的桥梁方向**。例如"把 in-context learning 用到越野可通行区域分割",合理的方向至少包括:
- ICL 本身(机制、为什么 work、demonstration/example selection、retrieval-augmented ICL);
- **视觉 / 多模态 ICL 与 in-context segmentation**(visual prompting、in-context segmentation、promptable/few-shot segmentation)——这是 ICL 与分割之间的桥梁,用户常没点名但往往是关键;
- 目标任务本身(off-road / unstructured traversable region & freespace detection:任务定义、数据集、现有方法、难点如域偏移与边界模糊);
- **样本编码与检索**(如何把 query 图像 + 语义编码成表示并检索相关 demonstration——用户明确要的方向)。

产出写入 `_survey/plan.md`(见下方模板)。**然后停下,触发闸门1**:把方向 + 预算摆给用户,问"要增删哪个方向?预算合适吗?"——未经确认不进入深读。

---

## Phase 1 — 逐方向有界检索(triage-then-deepen)

对每个已确认方向,执行**两层**,绝不对每条命中都做全文精读(那是 token 黑洞):

- **Tier-1 triage(便宜)**:对检索命中只看标题 + 摘要,给两行判断(是否相关 / 是否承重 → 留或弃)。维护一个 seen-set(arXiv id / 标题)避免重复抓取。
- **Tier-2 deep read(贵,受 cap)**:只有**承重**论文走 `SKILL.md` 全文精读,生成 `*-notes.md`。

每个方向跑完(或每 N 篇深读后)**汇报一次**(见 Progress)。

---

## Phase 2 — 综合与落地建议

1. 按 `references/synthesis.md` 生成本次调研范围的 `_landscape.md`(领域格局、谱系、争议、共识、跨论文异味、空白)。
2. 在其上生成 **`_recommendation.md`**——这才是调研目标的真正交付物。"把 A 用到任务 B"型建议的结构:
   - A 的机制中**与迁移相关**的部分;
   - 桥梁现状(如 visual / in-context segmentation 已能做到什么);
   - 任务 B 的现实(数据集、现有 SOTA、为什么难);
   - 关键子问题的可行方案(如样本编码 + 检索怎么做);
   - **2–3 个具体候选方案**(架构 / 路线),各自优劣,**每条主张标注由哪篇论文支撑**;
   - 空白与风险、证据薄弱处明确标注;
   - 一个可执行的下一步研究 / 实验计划。
3. 触发最终闸门:呈现 landscape + recommendation,确认是否符合预期 / 是否要补调研。

---

## 预算与防循环(用户在 kickoff 时设定,下面是默认值)

把这些当作硬旋钮,写进 `_survey/plan.md` 顶部:

- `max_directions`: 默认 5(超过要先过闸门)
- 每方向 `max_search_rounds`: 默认 3
- 每方向 `max_triage`: 默认 ~20 篇
- 每方向 `max_deep_reads`: 默认 5
- 全局 `max_total_deep_reads`: 默认 25
- `report_every`: 每完成 1 个方向或每 5 篇深读汇报一次

**饱和停止(防死循环的关键)**:
- **收益递减**:若连续 2 个 search round 命中的多为已在队列/已读论文(新论文 < ~30%),判定该方向 saturated,停止检索。
- **硬上限**:触到 `max_search_rounds` 或 `max_deep_reads` 立即停,不论是否"还想再看看"。
- **去重**:seen-set 防止反复抓同一篇。
- **不偷偷扩范围**:途中发现诱人的新方向,**不自动展开**,记到 `_survey/plan.md` 的"proposed_new_directions",留到下个闸门提给用户。

任一全局预算触顶 → 停止检索,直接进入 Phase 2 用已有材料综合,并在汇报里说明"因预算触顶,X 方向未充分覆盖"。诚实 > 假装全面。

---

## Progress 实时汇报(在对话里打印,并镜像到 `_survey/progress.md`)

每个汇报点给一段**简短**状态,不要长篇:
- 进度:方向 已完成 / 进行中 / 剩余;已 triage / 已深读 篇数;
- 预算:各项消耗 vs 上限;
- 关键发现:目前最重要的 2–3 个 takeaway 或意外;
- 范围变化:是否有 proposed_new_directions 或建议砍掉的方向;
- 下一步:接下来打算做什么。

---

## 状态文件(让调研可见、可恢复、可中断续跑)

放在 `_survey/` 下:
- `plan.md` — 研究计划 + 预算 + 每方向状态(todo / in-progress / done / saturated)+ proposed_new_directions。这是调研的"控制面板"。
- `progress.md` — append-only 进展日志。
- 各 `*-notes.md` + `_index.md`（主流程产出）。
- `_landscape.md` + `_recommendation.md`（最终交付）。

### `_survey/plan.md` 模板

```markdown
# Survey: <研究目标>

## Budgets
max_directions: 5 | per-dir search_rounds: 3 | per-dir triage: 20 | per-dir deep_reads: 5
global max_total_deep_reads: 25 | report_every: 1 direction

## Directions
| # | direction | why | status | triaged | deep_read |
|---|-----------|-----|--------|---------|-----------|
| 1 | in-context learning 基础 | 理解机制与 demo selection | todo | 0 | 0 |
| 2 | visual / in-context segmentation | ICL→分割的桥梁 | todo | 0 | 0 |
| 3 | off-road freespace / traversable detection | 目标任务现状与数据集 | todo | 0 | 0 |
| 4 | demonstration 编码与检索 | 编码 query+语义、检索相关样本 | todo | 0 | 0 |

## Proposed new directions (待用户确认,不自动展开)
- 

## Decisions log
- <date> 闸门1:用户确认/调整了 ...
```

---

## 闸门清单(human-in-the-loop,精简)

- **闸门1(必停)**:计划产出后、任何深读之前。问方向与预算。
- **方向边界闸门(有条件)**:仅在(a)要新增方向、(b)某预算将超、(c)发现暗示目标/范围该调整时才问;否则只汇报、继续,不打扰。
- **最终闸门**:呈现 landscape + recommendation,确认。

询问时用 AskUserQuestion / 直接提问,给清晰的"继续 / 调整 / 停止"选项,不要开放式地问"接下来呢"。