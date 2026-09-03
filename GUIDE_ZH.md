# claude-code-skill-marp-beamer 中文使用指南

一个用于在 Marp 中创建学术演示文稿的 Claude Code 技能 —— 深蓝色标题栏、三栏页脚、表格样式和定义块。从零构建，彻底修复现有 beamer 主题的常见 CSS 问题。

**Languages:** [English](README.md) · [中文](#概述)

---

## 概述

本技能为 Claude 提供完整参考，涵盖：

- 编写 Marp 幻灯片（Marpit 指令、图片语法、数学公式、VS Code 配置）
- 从零构建 beamer 风格 CSS 主题
- 诊断并修复四个 beamer CSS 问题（阴影列、缝隙线、段落间距、代码块底色）
- 生成学术演讲的幻灯片模板

## 技能结构

```
skill_marp_beamer/
├── SKILL.md                      # 入口：路由表 + 关键规则
├── references/
│   ├── marpit-syntax.md          # Marp 语法、指令、图片语法
│   ├── beamer-css.md             # CSS 架构、问题修复、颜色自定义
│   └── slide-templates.md        # 完整幻灯片模板 + 单页模式
└── assets/
    └── beamer.css                # 可直接复制使用的 CSS 文件
```

## 安装方法

### Claude Code（人工操作）

```
/plugin marketplace add chendakeng/claude-code-skill-marp-beamer
/plugin install marp-beamer@claude-code-skill-marp-beamer
```

### Claude Code（AI Agent 操作）

告诉你的 Agent：

> Install the marp-beamer skill from https://github.com/chendakeng/claude-code-skill-marp-beamer

### 手动安装

```bash
git clone https://github.com/chendakeng/claude-code-skill-marp-beamer ~/.claude/skills/marp-beamer
```

## 快速开始

1. 将 `assets/beamer.css` 复制到项目的 `.vscode/beamer.css`
2. 创建 `.vscode/settings.json`：
   ```json
   { "markdown.marp.themes": [".vscode/beamer.css"], "markdown.marp.html": true }
   ```
3. 重载 VS Code（`Cmd+Shift+P → Reload Window`）
4. 在 `.md` 文件中添加 frontmatter：
   ```yaml
   ---
   marp: true
   theme: beamer
   paginate: true
   footer: '**作者姓名** **演讲标题** **会议 · 日期**'
   ---
   ```
5. 使用 Claude Code 时，直接描述需求即可触发本技能，例如：
   - "帮我做一个学术报告的幻灯片"
   - "我的 Marp 表格右边有奇怪的阴影列，怎么修复？"
   - "定义块的标题栏和正文之间有一条细线"

## 配色：九个颜色变量，一次全改

主题的所有配色集中在 `:root` 的九个变量。在 frontmatter 的 `style:` 中整体覆盖，
不要只改 `--primary`，否则其余色阶仍停留在原色系：

```yaml
style: |
  :root {
    --primary:        #73216d;   /* 标题栏、表头、定义块标题 */
    --primary-dark:   #5a1957;   /* 页脚中段、定义块正文 */
    --primary-darker: #3f1240;   /* 页脚左段 */
    --primary-light:  #dda300;   /* h2 下划线、引用块左边框 */
    --bg-stripe2:     #faf4e8;   /* 表格偶数行 */
    --code-bg:        #f4dfb0;   /* 行内代码底色 */
    --code-fg:        #5a3a06;   /* 行内代码文字 */
    --code-border:    #dcc084;   /* 行内代码边框 */
    --table-border:   #e5d8e4;   /* 表格线 */
  }
```

以上为 CUHK 紫金配色。其他预设（SCNU 蓝、青、酒红、灰蓝）及"从一个校色推导整套
配色"的方法见 `references/beamer-css.md`。

**九个变量之外不要再写 `section.*` 规则。** 主题已内置九个单页样式类
（`small-text`、`large-text`、`tight`、`vcenter`、`center-table`、`small-table`、
`wide-table`、`wide-defblock`、`wide-quote`），用 `<!-- _class: 名称 -->` 直接调用即可。
若某条规则两个 deck 都需要，应写进 `beamer.css`，而不是各自复制到 frontmatter。

## 命令行渲染

```bash
marp deck.md --allow-local-files \
  --theme-set /绝对路径/.vscode/beamer.css \
  --pdf -o deck.pdf
```

**`--theme-set` 必须显式传入。** Marp CLI 不读取 `.vscode/settings.json`（那是
VS Code 插件专用配置）。缺少该参数时，CLI 会静默回退到 Marp 默认主题：没有标题栏、
没有页脚、配色全错，**而退出码仍是 0**。渲染成功不等于渲染正确，务必打开 PDF 查看。

## 本技能修复的 CSS 问题

### 问题一：表格阴影列

**症状：** 表格最后一列右侧出现一个空白列，背景色与表头相同，没有文字内容。

**原因：** 将 `background-color` 设置在 `<table>` 元素上时，当表格宽度大于实际列宽总和，背景色会溢出到空白区域。

**修复方案：**
```css
table {
  border-collapse: collapse;
  background: none;        /* 永远不要在 table 元素上设置背景 */
  width: fit-content;
}
```

**设计原则：** 背景色只应设置在 `th`、`td` 或 `tr` 上，而非 `table` 元素本身。

### 问题二：定义块的缝隙线

**症状：** 使用 `> #### 标题` 语法创建的定义块中，标题栏与正文之间出现细小的可见缝隙。

**原因：** `border-radius` 同时应用于 `h4` 和 `p` 子元素的四个角，导致两个子元素相交处露出父元素背景色。

**修复方案：**
```css
blockquote:has(> h4) { border-radius: var(--radius); overflow: hidden; }
blockquote:has(> h4) h4 { border-radius: 0; }
blockquote:has(> h4) p  { border-radius: 0; }
```

**设计原则：** `overflow: hidden` 让父元素的 `border-radius` 统一裁切所有子元素，子元素无需各自设置圆角。

### 问题三：行内代码在表格中"消失"

**症状：** 表格单元格里的行内代码（`` `字段名` ``）看不出是代码，与正文无异。

**原因：** 代码底色原本取 `--bg-stripe`，而表格偶数行底色取 `--bg-stripe2`。
代码块在表格中是叠在行底色之上，两者若同色系且明度接近（APSA 蓝色 deck 中相差约 2%），
边界就完全消失。

**修复方案：** 代码块使用独立变量，并保留 1px 边框：

```css
code {
  background: var(--code-bg);
  color: var(--code-fg);
  border: 1px solid var(--code-border);
}
```

**设计原则：** 换配色时 `--code-bg` 必须明显深于 `--bg-stripe2`，并且要在**偶数行**
上检查，而不是在白色幻灯片背景上，后者永远看起来正常。

### 问题四：段落上下多出的间距

**症状：** 加粗小标题与其下列表之间出现约 0.75em 的空隙。

**原因：** 主题里的 `* { margin: 0 }` 特异性为 0-0-0，而 Marp 内置样式表的
`p { margin: 0.5em 0 }` 特异性为 0-0-1，后者永远胜出。

**修复方案：** 用元素级选择器显式覆盖：

```css
p { margin: 0.15em 0; }
```

## 幻灯片模板示例

### 标题页

```markdown
<!-- _class: title -->

# 演讲标题

## 副标题

**作者姓名**
单位 · 日期
```

### 内容页（带节标题）

```markdown
<!-- header: 第一节：研究问题 -->

## 研究问题

- 要点一
- 要点二

> #### 核心概念
> 这是定义块的内容，标题栏会显示深蓝色背景。
```

### 表格页

```markdown
| 变量 | 系数 | 标准误 |
|------|------|--------|
| X1   | 0.23 | 0.05   |
| X2   | -0.14| 0.03   |
```

### 结束页

```markdown
<!-- _class: title -->

# 谢谢

**联系方式：** your@email.com
```

## Marp 常用指令速查

| 指令 | 类型 | 说明 |
|------|------|------|
| `marp: true` | 全局 | 启用 Marp |
| `theme: beamer` | 全局 | 应用 beamer 主题 |
| `paginate: true` | 全局 | 显示页码 |
| `footer: '**A** **B** **C**'` | 全局 | 三栏页脚 |
| `<!-- header: 节标题 -->` | 局部 | 更新当前页起的节标题 |
| `<!-- _class: title -->` | 单页 | 应用标题页样式 |
| `<!-- _paginate: false -->` | 单页 | 隐藏当前页页码 |

## 评测结果

针对三个典型任务（创建完整幻灯片、修复阴影列、修复缝隙线）进行测试：

| | 使用技能 | 不使用技能 |
|---|---|---|
| 通过率 | **100%** | 80% ± 28% |

本技能的核心价值在于提供精确的三属性表格修复方案 —— 不使用技能时，Claude 能正确识别问题的大致原因，但常常遗漏 `background: none` 和 `width: fit-content`。

## 参考资源

- [Marp 官网](https://marp.app/) — Markdown 演示生态系统
- [Marpit 文档](https://marpit.marp.app/) — 指令和图片语法完整参考
- [neobeam](https://github.com/mikael-ros/neobeam) — 本主题配色方案和布局的原始灵感来源
