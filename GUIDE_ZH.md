# claude-code-skill-marp-beamer 中文使用指南

一个用于在 Marp 中创建学术演示文稿的 Claude Code 技能 —— 深蓝色标题栏、三栏页脚、表格样式和定义块。从零构建，彻底修复现有 beamer 主题的常见 CSS 问题。

**Languages:** [English](README.md) · [中文](#概述)

---

## 概述

本技能为 Claude 提供完整参考，涵盖：

- 编写 Marp 幻灯片（Marpit 指令、图片语法、数学公式、VS Code 配置）
- 从零构建 beamer 风格 CSS 主题
- 诊断并修复两个最常见的 beamer CSS 问题
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
   { "markdown.marp.themes": [".vscode/beamer.css"] }
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

## 本技能修复的两个 CSS 问题

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
