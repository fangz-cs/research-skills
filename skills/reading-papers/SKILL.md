---
name: reading-papers
description: Critically read and analyze an academic paper and produce a structured bilingual reading note. Evaluates rather than summarizes — across motivation, problem, method/novelty, experiments, related work, seed potential, and future work — actively hunting for weaknesses, hidden assumptions, and "smells". Use whenever the user asks to read, analyze, critique, review, or take notes on a paper, PDF, or arXiv link. Trigger this even for casual phrasings like "看看这篇论文怎么样", "这篇值不值得读", or "帮我精读". For a pure one-line "what is this about", a lightweight verdict mode is available. Also use this skill in Synthesis mode to weave previously-read papers into a comprehensive view of a field — trigger when the user says things like "把我读过的这些串起来", "这个领域现在什么格局", "综述一下", "build a field map", or "compare what I've read". And use Survey mode for an end-to-end systematic literature survey toward a research goal (autonomously decomposing it into sub-areas, bounded retrieval, progress reports, human checkpoints, and a final application recommendation) — trigger on "系统调研", "survey the literature on", "调研一下如何把 X 用到 Y", or "do a literature review".
---

# Reading Papers (论文精读)

Produce a rigorous, **critical** reading note for one paper. The goal is not to summarize — it is to **evaluate**. The default failure mode to avoid is restating the abstract and praising everything. Actively look for weaknesses, hidden assumptions, unfair comparisons, and "smells" (异味), not just merits. Every dimension ends in a judgment with a reason.

## Output Conventions

- **Language**: 中英双语。正文用简体中文叙述,关键术语 / 方法名 / 指标保留英文(如 attention、ablation、SOTA、baseline)。
- **Format**: 结构化 Markdown 阅读笔记,保存为文件(轻量模式除外,见 Workflow)。
- **Filename**: `<short-paper-id>-notes.md`(如 `transformer-notes.md`)。
- **Save location**: 若当前工作目录看起来是一个 paper-reading / 笔记仓库(目录里已有 `*-notes.md`,或有 `papers/`、`notes/` 这类子目录,或用户明确说"存到我的论文库"),就存到当前目录;否则存到默认输出目录。判断不确定时,直接问一句存哪里,而不要默默猜。
- **Delivery(怎么让用户拿到)**: 写完文件还不够——必须确保用户真能拿到它。
  - **有文件系统 / 沙箱环境**:用环境提供的文件呈现机制把文件交付给用户(让它可下载 / 可预览),而不是只甩一句 `/home/...` 路径——用户打不开那种路径。
  - **没有可用文件系统的纯聊天环境**:无法存文件,直接把整篇笔记**输出在对话里**(用 Markdown 代码块或正文),不要假装存了文件。
  - 不确定当前是哪种环境时,先确认能否写文件,不能就退回到对话内输出。
- **Length budget**: 整篇笔记控制在 ~600–1200 字中文为宜。每个维度 2–5 句,有判断、有理由即可,不要把论文复述一遍。信息越充分可以写越细,但不要为了凑长度灌水。
- **Tone**: 批判性、有判断力。每个判断都要给理由。

## File Organization (文件组织)

核心原则:**分类是"视图",不是"存储方式"。** 不要把多篇论文按内容合并进一个大 md——那会强加单一分类(论文天然多归属)、破坏单篇可寻址性(`relates_to` / 重生成依赖它),并退化成反复就地改写。

- **存储**:一篇论文 = 一个**不可变** `*-notes.md`,写一次就稳定,不合并、不重写。这是真相源。
- **分类**:靠 front-matter 的 **tag**(`field` 粗轴、`topics` 细轴多属),**不靠文件夹**。一篇可同时属于多个 topic。
- **导航 / 主题视图**:`_index.md`(我读过什么)+ `_landscape.md`(某领域格局,可按 `topics` 过滤后重生成)。**"按内容归类"发生在这里、按需生成,而不是固化在目录结构里。**
- **何时才用文件夹**:仅当跨**明显不同的领域**读且量大时,按 `field` 开顶层文件夹(粗、稳定、不易misfile),每个 field 各有自己的 `_index.md` / `_landscape.md`;field 内部保持扁平 + tag。
- **结论**:笔记多≠杂乱。杂乱来自缺导航层,而导航层(index + landscape)已经建好——所以放心一篇一个文件。

## Workflow

1. **判断模式**:
   - **轻量模式(lightweight)**:用户只想要"这篇大概讲啥 / 值不值得读"这类快速结论时,不必写文件。直接在对话里给一句话概括 + 2–3 句总评(亮点 / 隐患 / 是否值得深读)即可。
   - **精读模式(full,默认)**:用户要求"精读 / 分析 / 批判 / 做笔记"时,走完整六维度 + 存文件流程。
   - **调研模式(survey)**:用户给的是一个**研究目标 / 调研课题**(而非单篇论文),如"系统调研如何把 X 用到 Y"。此时读取 **references/survey.md** 并按它的状态机执行(自主拆方向、有界检索、实时汇报、关键节点确认、最终给落地建议);其中每篇承重论文仍回到本文件的精读流程。

2. **获取论文内容**:读取用户提供的 PDF / 链接 / 文本。
   - 只有 arXiv ID 或标题时,先用可用工具获取正文(arXiv 需要确切 URL,如 `https://arxiv.org/abs/XXXX.XXXXX`)。
   - **关键**:Method、Experiments、Related Work、ablation 这些维度**只看摘要是评不了的**。若最终只拿到 abstract / 部分正文,**必须在笔记开头显式声明哪些维度信息不足、无法评估**,对应维度写「未读到正文,无法判断」,绝不基于摘要臆造一个看起来很自信的评价。诚实 > 完整。

3. **判断论文类型,选择透镜**(见下面 Paper Type)。默认模板按经验性 ML/CS 论文设计;其它类型需要调整重点。

4. **逐维度分析**:按模板填写,每个维度都要下明确结论(如「motivation 成立 / 有异味」),并给理由。

5. **保存并交付笔记**(精读模式):写入 Markdown,文件头含标题、作者、年份、出处、链接、信息完整度声明。**写完后按 Output Conventions 的 Delivery 把文件真正交付给用户**(可下载 / 可预览,或在无文件系统时直接输出在对话里),不要只报一个路径就结束。

6. **给出总评**:在对话里用 2–3 句话给整体判断(是否值得深读、最大亮点、最大隐患)。

7. **追加索引账本**(精读模式,且存在于笔记目录时):往同目录的 `_index.md` **追加一行**本文条目。这是 append-only 的无损账本,只追加不删改,极便宜,是日后生成领域全景的输入,也是"我到底读了什么"的快速总览。不要在这一步去重写全景文档。表格格式:
   ```markdown
   | id | year | problem | method_family | delta | my_take | confidence |
   |----|------|---------|---------------|-------|---------|-----------|
   | transformer-notes | 2017 | seq2seq 依赖 recurrence | attention | 纯 attention 去掉 recurrence | 范式级,值得深读 | high |
   ```

> 想把读过的多篇论文织成一个领域的整体认知,见 **references/synthesis.md**。

## Paper Type (先判断论文类型,再选维度重点)

模板默认针对**经验性 ML / CS 论文**(有方法、有 baseline、有实验)。其它类型透镜不同:

- **Empirical / 方法类**(默认):六维度全部适用,**Experiments 维度是攻击重点**。
- **Theory / 理论类**:没有传统实验。把 Experiments 维度替换为「证明 / 假设审查」——核心定理是否成立?假设是否过强或不现实?有没有 toy example 或合理性验证?
- **Survey / 综述**:Method 与 Experiments 弱化。重点变为:分类体系(taxonomy)是否清晰自洽?覆盖是否全面、有无明显遗漏?是否只是罗列还是真有 organizing insight?
- **Position / 观点类**:重点为论证链是否严密、是否回应了显而易见的反驳、证据是否 cherry-picked。

在笔记开头标注你判断的论文类型,并说明因此调整了哪些维度。

## Six Dimensions (六个核心维度)

逐条评估,每条都要有结论 + 理由,不要只描述论文怎么说。

1. **Motivation(动机)**
   - 论文的 motivation 是什么?逻辑链是否完整?
   - **找异味**:是否为了创新而创新?是否夸大痛点?是否回避了更简单的替代方案?

2. **Problem(问题)**
   - 核心问题是什么?
   - 这个问题是**广泛存在 / 被社区讨论**,还是小众 / 人造问题?
   - 重要性如何?解决它的价值有多大?

3. **Method & Core Novelty(方法与核心创新)**
   - 方法的关键步骤 / 架构。
   - **真正的 delta 是什么**?区分「真创新」与「换皮 / 组合 / 重命名已有概念」。
   - 方法是否能支撑 motivation 与 problem?

4. **Experiments & Evaluation(实验与评估)** ← 经验类论文的攻击重点
   - 实验设置:数据集、baseline、指标、算力。
   - **公平性审查**(这里最容易藏异味):
     - baseline 是否是**最新、最强**的对手,还是挑了弱的对比?
     - 数据集 / 任务是否被**挑选**以利于本方法?
     - 提升是否来自方法本身,还是更多算力 / 更大模型 / 更多调参?
     - 是否有**统计显著性 / 多次运行**,还是单次 cherry-picked 结果?
   - **Ablation**:关键组件是否做了消融?有没有「声称重要却没验证」的部分?
   - 结论:实验是否真的支撑了论文的 claim?(很多论文败在这一步)

5. **Related Work(相关工作)**
   - 关键相关工作(尤其最直接的 baseline / 前驱)。
   - 本文相对它们的定位与区别。
   - 是否有**该引而未引**的重要工作(可能暗示作者不熟悉领域,或刻意回避对比)?
   - **连接已读论文**(让笔记不成孤岛):若当前笔记目录里已有其它 `*-notes.md`,扫一眼,显式判断本文与它们的关系——延续(builds_on)、竞争(competes_with)、矛盾(contradicts)、印证(confirms)还是推广(generalizes)?把这些关系写进 front-matter 的 `relates_to`。**矛盾关系最值钱**,要在正文点出"本文结论与 X 打架"。

6. **Future Work & Improvements(改进空间与未来工作)**
   - 局限性(方法、实验、假设、泛化性)。
   - 区分「跟进性小改」与「值得自己做的研究机会」。

### (可选)Citation / Seed Potential(高引 / 种子潜力)

**预测一篇论文会不会高引本质上很难,这是低置信度判断**。只在有把握时给,且必须标注置信度;没把握就直说「不好预测」,不要硬编一个笃定结论。
- 判断依据:问题普适性、方法可迁移性、是否开辟新方向、复现成本、开源 / 数据可得性、timing。

## Note Template

每篇笔记**开头必须有 YAML front-matter**。这是让单篇笔记日后能被聚合成领域全景的地基——正文给人读,front-matter 给"综述模式"机器读。字段保持原子、简短。

```markdown
---
paper: <Title>
year: <YYYY>
venue: <venue>
type: <empirical / theory / survey / position>
field: <粗粒度领域,如 ML / genomics / economics;决定它归到哪个 _index/_landscape>
topics: [<主题标签,可多个,如 attention, efficiency, long-context>]   # 分类靠 tag 不靠文件夹,允许一篇多属
problem: <一句话:论文解决什么>
method_family: <方法属于哪一类,如 attention-based / RL / diffusion>
key_claim: <论文最核心的主张,一句话>
delta: <相对已有工作真正的新东西,一句话>
datasets: [<dataset1>, <dataset2>]
relates_to:           # 与已读论文的关系,没有就留空
  - {note: <other-id>-notes.md, rel: builds_on}      # builds_on / competes_with / contradicts / confirms / generalizes
my_take: <你自己的一句话判断:可信度 / 是否值得深读>
confidence: <high / medium / low,取决于读到多少正文>
---

# <Paper Title>

- **Authors / Year / Venue**:
- **Link**:
- **Paper type(论文类型)**: <empirical / theory / survey / position>,因此调整了:<...>
- **信息完整度**: <读到全文 / 仅读到 abstract,以下维度无法评估:...>
- **One-line summary(一句话概括)**:

## 1. Motivation(动机)
- 动机:
- 是否成立 / 是否有异味(理由):

## 2. Problem(问题)
- 核心问题:
- 普适性 & 重要性(理由):

## 3. Method & Core Novelty(方法与创新)
- 方法概述:
- 核心创新点(vs 已有工作的 delta):

## 4. Experiments & Evaluation(实验与评估)
- 实验设置(数据集 / baseline / 指标):
- 公平性审查(baseline 是否够强、是否 cherry-picked、提升来源):
- Ablation 是否充分:
- 结论:实验是否支撑 claim:

## 5. Related Work(相关工作)
- 关键相关工作:
- 本文定位与区别:
- 缺失的重要引用(如有):

## 6. Future Work & Improvements(改进空间)
- 局限性:
- 可做的未来工作 / 研究机会:

## (可选)Citation / Seed Potential(高引潜力,低置信度)
- 判断(标注置信度):
- 依据:

## Overall Verdict(总评)
- 是否值得深读:
- 最大亮点 / 最大隐患:
```

## Synthesis Mode (领域综述模式) → 见 references/synthesis.md

当用户想把读过的多篇论文织成**一个领域的整体认知**(而非一堆独立报告)时——触发语如"把我读的这些串起来 / 这个领域什么格局 / 综述一下 / build a field map"——**读取 `references/synthesis.md` 并按它执行**。

核心思路(细节在该文件):单篇笔记 + front-matter 是唯一真相源;领域全景 `_landscape.md` 是按需**重新生成**的派生产物(不就地改写,避免越改越烂),输入是各篇 front-matter 与 `_index.md` 账本。产出一张**有判断、能找跨论文异味**的领域地图:谱系、核心问题状态、争议与矛盾、共识、空白与机会、个人 thesis。

## Guidance

- **下结论**:每个维度结尾必须有一句明确判断,而不是只罗列论文内容。这是这个 skill 和普通"论文总结"最大的区别。
- **找异味**:主动质疑 motivation 与实验设置——cherry-picked baseline、不公平对比、缺失 ablation、过强假设、提升来源不明,都要揪出来。
- **区分创新真伪**:警惕「把 A 套到 B 上」「换数据集刷分」「重命名已有概念」这类伪创新。
- **诚实标注不确定**:信息不足时(没读到正文、没看到实验细节),明确写「未知 / 需补充」,**绝不臆造**。基于摘要给出的自信评价是这个 skill 最该避免的失败模式。