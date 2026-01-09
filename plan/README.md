# plan

質問で要件を深掘りしてからプランニングする Claude Code プラグイン。

## 概要

曖昧な要件から始まるタスクに対して、`AskUserQuestion` ツールで対話的に要件を明確化し、高精度な実装計画を立案する。

## 構成

```
plan/
├── .claude-plugin/
│   └── plugin.json
├── skills/
│   └── digging/
│       ├── SKILL.md      # スキル本体
│       └── README.md     # 詳細説明
└── hooks/
    ├── plan-reminder.md      # 未完了計画のリマインダー
    └── plan-status-update.md # 計画参照時の進捗更新
```

## 機能

### digging スキル

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

### plan-reminder hook

セッション開始時に未完了の計画をリマインドする。

**機能**:
- `./.claude/plans/*.md` と `~/.claude/plans/*.md` をチェック
- `status: completed` 以外の計画を通知
- 1週間以上前の古い計画は削除するか確認

### plan-status-update hook

計画ファイルを参照した時に進捗を更新する。

**トリガー**: `.claude/plans/*.md` を Read した時

**機能**:

| status | 動作 |
|--------|------|
| `pending` | 作業開始するか確認 → `in_progress` に更新 |
| `in_progress` | 進捗記録 or 完了を選択 → ✅ マーク付与 or `completed` に更新 |
| `completed` | 削除するか確認 |

**進捗マークの例**:
```markdown
## 実装手順

1. ✅ データベース設計
2. ✅ API エンドポイント作成
3. フロントエンド実装  ← 次はここ
4. テスト
```

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
# 相談内容を引数で指定
/plan:dig ログイン機能を追加したい

# 引数なしで実行（対話的に相談内容を聞く）
/plan:dig
```

## 実行フロー

```
/plan:digging
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