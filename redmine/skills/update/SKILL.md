---
description: Redmineチケット更新・削除・コメント記入スキル。redmine-cli を使ってチケットの更新・削除・コメント記入を対話的に行う。「redmine:update」「チケットを更新」「ステータス変更」「コメントして」「チケット削除」で起動。
---

# Redmine チケット更新・削除・コメント

redmine-cli を使って、チケットの更新・削除・コメント記入を対話的に支援する。

## 利用する CLI コマンド

すべてのコマンドは JSON を stdout に出力する。Bash ツールで実行し、出力をパースして整形表示する。

- `redmine-cli update-issue <id> [flags]` — チケット更新（フィールド変更・コメント記入）
- `redmine-cli delete-issue <id>` — チケット削除
- `redmine-cli get-issue <id>` — チケット詳細取得（更新前の現在状態確認用）
- `redmine-cli search` — 対象チケットの特定
- `redmine-cli trackers` — トラッカー一覧取得（名称→ID解決）
- `redmine-cli statuses` — ステータス一覧取得（名称→ID解決）
- `redmine-cli priorities` — 優先度一覧取得（名称→ID解決）
- `redmine-cli members --project <id>` — メンバー一覧取得（担当者の名称→ID解決）
- `redmine-cli categories --project <id>` — カテゴリ一覧取得
- `redmine-cli versions --project <id>` — バージョン一覧取得
- `redmine-cli config list` — プロファイル一覧取得

すべてのコマンドに `--profile <name>` を付与してプロファイルを指定する（デフォルトプロファイル使用時は省略可）。

## 大前提

- **確認必須**: 更新・削除の実行前に必ずユーザーに確認プロンプトを表示する
- **削除は特に慎重に**: 削除操作は取り消せないため、対象チケットの内容を表示した上で再確認する
- チケット情報は参考であり、最新の状態は Redmine 本体で確認するよう補足する

## フロー

### -1. 前提チェック

1. `which redmine-cli` で CLI がインストールされているか確認する
2. **未インストールの場合**、以下を案内して終了する:
   - macOS: `brew install chippy-ao/tap/redmine-cli`
   - Windows: GitHub Releases (https://github.com/chippy-ao/redmine-cli/releases) から ZIP をダウンロードし、展開して `redmine-cli.exe` を取得。PATH に追加すると便利
   - その他: `go install github.com/chippy-ao/redmine-cli@latest`

### 0. プロファイル選択

`redmine-cli config list` を実行してプロファイルを確認する。

- **0件**: 「プロファイルが未設定です。今から設定しましょう」と伝え、AskUserQuestion でプロファイル名・URL・API キーを順に聞いて `redmine-cli config add` を実行する
- **1件**: そのプロファイルを使用する旨を伝え、次のステップに進む
- **複数**: AskUserQuestion で使用するプロファイルを選択

### 1. 対象チケットの特定

ユーザーの入力からチケット ID を特定する。

- **ID が明示されている場合**: そのまま使用
- **ID が不明な場合**: AskUserQuestion でチケット番号を確認、または `redmine-cli search` で検索して候補を表示

### 2. 現在の状態を確認

`redmine-cli get-issue <id> --profile <p>` で対象チケットの現在の状態を取得し、表示する。

### 3. 操作の判定

ユーザーの入力から操作を判定する:

- **更新**: フィールド変更（ステータス、担当者、優先度など）
- **コメント**: notes によるコメント記入
- **更新 + コメント**: フィールド変更とコメントの同時実行
- **削除**: チケットの削除

### 4a. 更新・コメントの場合

ユーザーの入力から変更内容を読み取り、不足分のみ質問する。

名称→ID解決が必要なフィールド:
- **ステータス**: `redmine-cli statuses --profile <p>` で一覧取得
- **トラッカー**: `redmine-cli trackers --profile <p>` で一覧取得
- **優先度**: `redmine-cli priorities --profile <p>` で一覧取得
- **担当者**: `redmine-cli members --project <proj> --profile <p>` で一覧取得
- **カテゴリ**: `redmine-cli categories --project <proj> --profile <p>` で一覧取得
- **バージョン**: `redmine-cli versions --project <proj> --profile <p>` で一覧取得

変更内容を一覧表示し、AskUserQuestion で「実行する / 修正する / キャンセル」を確認。

「実行する」が選ばれたら:

```bash
redmine-cli update-issue <id> --profile <p> [--status-id N] [--assigned-to-id N] [--tracker-id N] [--priority-id N] [--subject "題名"] [--description "説明"] [--category-id N] [--version-id N] [--notes "コメント"] [--private-notes]
```

### 4b. 削除の場合

対象チケットの情報（ID・件名・ステータス・担当者）を表示し、AskUserQuestion で「本当に削除しますか？この操作は取り消せません」と確認。

「削除する」が選ばれたら:

```bash
redmine-cli delete-issue <id> --profile <p>
```

### 5. 結果表示と次のアクション

操作結果を表示し、次のアクションを**平易な言葉**で提案する:

- **更新後**: 更新されたことを伝え、必要に応じて `get-issue` で最新状態を表示
- **削除後**: 削除されたことを伝える

提案する次のアクション:
- **別のチケットを更新する**: 同じスキルで継続
- **チケットを検索する**: `redmine:search` スキルへ案内
- **チケットを作成する**: `redmine:create` スキルへ案内

## エラーハンドリング

- **CLI 未インストール**: `which redmine-cli` で検出。OS に応じたインストール方法を案内
- **プロファイル未設定**: `redmine-cli config list` で空を検出。インラインで config add フローを実行
- **認証エラー・接続エラー**: 「Redmine への接続でエラーが発生しました。以下を確認してください: (1) プロファイルの URL が正しいか (2) API キーが有効か (3) Redmine サーバーが稼働しているか」と案内
- **チケット未発見 (404)**: 「指定されたチケットが見つかりません。チケット番号を確認してください」と案内
- **権限エラー (403)**: 「このチケットの更新/削除権限がありません。Redmine の管理者に権限を確認してください」と案内
- **バリデーションエラー (422)**: Redmine からのエラーメッセージをそのまま表示し、修正を促す
