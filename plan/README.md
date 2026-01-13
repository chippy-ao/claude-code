# plan

質問で要件を深掘りしてからプランニングする Claude Code プラグイン。

## 概要

曖昧な要件から始まるタスクに対して、`AskUserQuestion` ツールで対話的に要件を明確化し、高精度な実装計画を立案する。

## 構成

```
plan/
├── .claude-plugin/
│   └── plugin.json
├── commands/
│   └── check.md          # 計画管理コマンド
├── skills/
│   └── dig/
│       ├── SKILL.md      # スキル本体
│       └── README.md     # 詳細説明
└── hooks/
    ├── hooks.json        # hook 定義
    └── check-plans.sh    # 未完了計画の通知
```

## 機能

### dig スキル

要件を深掘りして計画を立案するスキル。

**特徴**:
- `EnterPlanMode` で Plan モードに入り計画を策定
- `AskUserQuestion` で 3-5 問程度の質問により要件を明確化
- CLAUDE.md / rules に沿った質問と計画を作成
- 計画は `$HOME/.claude/plans/` に自動保存

**トリガーフレーズ**:
- 「要件を整理して」
- 「プランを立てて」
- 「計画を作って」
- 「深掘りして」

### /plan:check コマンド

計画ファイルを管理するコマンド。

**機能**:
- `~/.claude/plans/` と `./.claude/plans/` の計画ファイルを一覧表示
- 複数選択で一括操作 or 個別操作
- status の更新（pending / in_progress / completed）
- 計画ファイルの削除

### SessionStart hook

セッション開始時に未完了の計画を通知する。

**機能**:
- `./.claude/plans/*.md` と `~/.claude/plans/*.md` をチェック
- `status: completed` 以外の計画を通知
- `/plan:check` コマンドへの誘導

## 計画ファイル

### 保存先

`$HOME/.claude/plans/`（Plan モードが自動保存）

### フォーマット

```yaml
---
title: 計画のタイトル
status: pending
created: 2025-01-09T14:30:00+09:00
started: 2025-01-09T15:00:00+09:00      # in_progress 時に追加
completed_at: 2025-01-09T18:00:00+09:00 # completed 時に追加
---

## 概要
...

## 実装手順
...
```

### ステータス

| status | 説明 |
|--------|------|
| `pending` | 未着手 |
| `in_progress` | 実装中 |
| `completed` | 完了 |

## 使い方

```bash
# 計画を立てる（相談内容を引数で指定）
/plan:dig ログイン機能を追加したい

# 計画を立てる（対話的に相談内容を聞く）
/plan:dig

# 計画を管理する（status 更新、削除）
/plan:check
```

## 実行フロー

```
/plan:dig
    ↓
1. 初期化：CLAUDE.md / rules を読み込み
    ↓
2. Plan モード移行：EnterPlanMode
    ↓
3. 質問フェーズ：AskUserQuestion で要件明確化
    ↓
4. 合意確認：整理した要件を確認
    ↓
5. 計画立案：実装計画を作成
    ↓
6. 保存：$HOME/.claude/plans/ に自動保存
    ↓
7. 完了：パスと概要を通知
```

## 設計思想

### 単一責任

このスキルは「深掘り + 計画立案」に特化する。実装は別のエージェントや rules/skills に委譲する設計。

### CLAUDE.md / rules 連携

プロジェクト固有のルールを読み込み、質問と計画の両方に反映させる。

## インストール

### マーケットプレイス経由（推奨）

```bash
# マーケットプレイスを登録
/plugin marketplace add chippy-ao/claude-code

# プラグインをインストール
/plugin install plan@chippy-ao-plugins
```

### ローカルディレクトリ指定

```bash
claude --plugin-dir /path/to/plan
```

## ライセンス

MIT