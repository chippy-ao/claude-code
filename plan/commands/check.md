---
name: check
description: 計画ファイルの一覧表示と状態管理（status更新・削除）
allowed-tools:
  - AskUserQuestion
  - Read
  - Edit
  - Glob
  - Grep
  - Bash
  - TodoWrite
---

# /plan:check コマンド

計画ファイルを管理するコマンド。

## 実行フロー

### 1. 計画ファイルのスキャン

以下のディレクトリから `.md` ファイルをスキャンする:
- `~/.claude/plans/`
- `./.claude/plans/`

各ファイルの frontmatter から以下を抽出:
- `title`: 計画のタイトル
- `status`: 状態（pending / in_progress / completed）
- `created`: 作成日時

### 2. 計画の選択

AskUserQuestion を使って、操作対象の計画を選択させる。

**multiSelect: true** で複数選択可能にする。

選択肢の形式:
```
[title] (status: [status]) - [ファイルパス]
```

計画が存在しない場合は「計画ファイルが見つかりませんでした」と伝えて終了。

### 3. 操作方法の選択

選択された計画が複数の場合、AskUserQuestion で操作方法を選択させる:
- **一括更新**: 全ての選択に同じ操作を適用
- **個別操作**: 各計画ごとに操作を選択

選択が1つの場合は自動的に個別操作へ。

### 4. 操作の実行

#### 一括更新の場合

AskUserQuestion で操作を選択:
- **completed に更新**: status を completed に変更、completed_at を追加
- **in_progress に更新**: status を in_progress に変更
- **pending に更新**: status を pending に変更
- **削除**: ファイルを削除

選択した操作を全ての計画に適用。

#### 個別操作の場合

各計画について AskUserQuestion で操作を選択:
- **completed に更新**: status を completed に変更、completed_at を追加
- **in_progress に更新**: status を in_progress に変更
- **pending に更新**: status を pending に変更
- **削除**: ファイルを削除
- **スキップ**: 何もしない

### 5. 実行

- status 更新: Edit ツールで frontmatter を編集
- 削除: Bash で `rm` コマンドを実行

### 6. 完了報告

処理結果をまとめて報告:
- 更新した計画の数と新しい status
- 削除した計画の数
- スキップした計画の数

## 注意事項

- frontmatter の `.pending-review` などの隠しファイルは除外する
- completed_at は ISO 8601 形式（例: 2026-01-13T14:30:00+09:00）
- 削除前に確認のメッセージは不要（選択時点で確定）
