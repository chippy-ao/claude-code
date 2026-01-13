---
name: dig
description: 質問で要件を深掘りしてからプランニングする。曖昧な要件を明確化し、整理した内容をプランとして出力する。ユーザーが「要件を整理して」「プランを立てて」「計画を作って」「深掘りして」「plan dig」と言った時、または曖昧な要件を構造化された実装計画に変換する必要がある時に使用する。
context: fork
user-invocable: true
allowed-tools:
  - EnterPlanMode
  - ExitPlanMode
  - AskUserQuestion
  - Read
  - Glob
  - Grep
  - Write
  - TodoWrite
---

# Dig スキル

## 実行フロー

### 1. 初期化

CLAUDE.md と rules の読み込み:
- `.claude/CLAUDE.md` または `CLAUDE.md` を確認
- `.claude/rules/` 内のルールファイルを確認
- 質問・計画に反映する

引数確認:
- 引数あり → 相談内容として認識、質問フェーズへ
- 引数なし → AskUserQuestion で相談内容を質問

### 2. Plan モード移行

**EnterPlanMode ツールを使用して Plan モードに入る。**

### 3. 質問フェーズ

AskUserQuestion で 3-5 問程度の質問を設定:

| 観点 | 確認内容 |
|------|----------|
| 目的 | 何を達成したいのか？ |
| スコープ | 対象範囲と制約は？ |
| 技術選定 | 技術・ツールの制約は？ |
| 優先順位 | トレードオフの判断基準は？ |
| 既存資産 | 参考にすべき既存コード・ドキュメントは？ |

ルール:
- 1回の AskUserQuestion で最大4問まとめて聞く
- CLAUDE.md / rules に沿った質問内容にする
- 曖昧な点がなくなるまで繰り返す
- 「もう十分」等の回答で次へ進む

### 4. 合意確認

整理した要件をユーザーに確認:

```markdown
## 整理した要件

### 目的
[明確化された目的]

### スコープ
[対象範囲と制約]

### 技術方針
[技術選定や方針]

### 優先順位
[重要な要素とトレードオフ]
```

AskUserQuestion で「この整理内容で認識は合っていますか？」と確認。

### 5. 計画立案

CLAUDE.md / rules に沿った実装計画を立案:
- 実装手順（ステップバイステップ）
- 変更対象ファイル
- 注意点・リスク
- 依存関係

### 6. 計画保存

計画ファイルの frontmatter:

```yaml
---
title: [計画のタイトル]
status: pending
created: [ISO 8601 形式の日時]
---
```

status: `pending` | `in_progress` | `completed`

### 7. 完了

ExitPlanMode で終了し、以下を伝える:
1. 計画ファイルのパス
2. 計画の概要
3. 「このファイルを参照して実装を依頼できます」

## 注意事項

- 質問は具体的に、回答の重要性を説明
- トレードオフ付きの選択肢を提供
- 信頼度をパーセンテージで開示（例: 信頼度：85%）
- CLAUDE.md / rules との整合性を維持