---
name: create
description: Redmineチケット作成支援スキル。redmine-cli を使ってチケットを対話的に作成する。「redmine:create」「チケットを作って」「チケット起票」「新規チケット」で起動。
---

# Redmine チケット作成

redmine-cli を使って、チケットの作成を対話的に支援する。

## 利用する CLI コマンド

すべてのコマンドは JSON を stdout に出力する。Bash ツールで実行し、出力をパースして整形表示する。

- `redmine-cli create-issue` — チケット作成
- `redmine-cli projects` — プロジェクト一覧取得
- `redmine-cli trackers` — トラッカー一覧取得（名称→ID解決）
- `redmine-cli statuses` — ステータス一覧取得（名称→ID解決）
- `redmine-cli categories --project <id>` — カテゴリ一覧取得
- `redmine-cli versions --project <id>` — バージョン一覧取得
- `redmine-cli config list` — プロファイル一覧取得

すべてのコマンドに `--profile <name>` を付与してプロファイルを指定する（デフォルトプロファイル使用時は省略可）。

## 大前提

- **作成専用**: チケットの更新・削除はこのスキルではできない
- **確認必須**: チケット作成前に必ずユーザーに確認プロンプトを表示する
- **1回1チケット**: 1回の操作で1チケットのみ作成する
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

- **0件**: 「プロファイルが未設定です。今から設定しましょう」と伝え、AskUserQuestion でプロファイル名・URL・API キーを順に聞いて `redmine-cli config add` を実行する。設定完了後、そのまま作成フローに継続する
- **1件**: そのプロファイルを使用する旨を伝え、次のステップに進む
- **複数**: AskUserQuestion で使用するプロファイルを選択

### 1. プロジェクト選択

`redmine-cli projects --profile <p> --limit 100` でプロジェクト一覧を取得し、AskUserQuestion で選択。

- 親プロジェクト・サブプロジェクトの関係がある場合は、階層が分かるように表示する
- ユーザーの入力にプロジェクトを示唆する表現がある場合、該当するプロジェクトを候補として強調する

### 2. チケット情報の収集

ユーザーの最初の入力から読み取れる情報は自動的に設定し、不足分のみ質問する。

AskUserQuestion で以下を順に収集する:

1. **件名** (必須): ユーザーの入力をそのまま使用
2. **説明** (任意): ユーザーの入力をそのまま使用
3. **トラッカー** (任意): `redmine-cli trackers --profile <p>` で一覧取得し、名称で選択→ID解決
4. **優先度** (任意): ユーザーが指定した場合のみ。ID を直接指定（priorities コマンドは未実装のため）
5. **担当者** (任意): ユーザーが指定した場合のみ。ID を直接指定
6. **対象バージョン** (任意): `redmine-cli versions --project <proj> --profile <p>` で一覧取得し、名称で選択→ID解決
7. **カテゴリ** (任意): `redmine-cli categories --project <proj> --profile <p>` で一覧取得し、名称で選択→ID解決（権限エラー時はスキップ）
8. **親チケット** (任意): ユーザーがチケット番号を指定した場合のみ

### 3. 確認と実行

収集した情報を一覧表示し、AskUserQuestion で「作成する / 修正する / キャンセル」を確認。

「作成する」が選ばれたら:

```bash
redmine-cli create-issue --profile <p> --project <proj> --subject "件名" [--description "説明"] [--tracker-id N] [--priority-id N] [--assigned-to-id N] [--version-id N] [--category-id N] [--parent-issue-id N] [--estimated-hours N] [--private]
```

### 4. 結果表示と次のアクション

作成されたチケットの情報を見やすく表示し、次のアクションを**平易な言葉**で提案する:

- **関連チケットを追加する**: `redmine:relation` スキルへ案内
- **子チケットを作成する**: 同じスキルで `--parent-issue-id` を設定して再度作成
- **別のチケットを作成する**: 同じスキルで新規作成
- **検索に戻る**: `redmine:search` スキルへ案内

## エラーハンドリング

- **CLI 未インストール**: `which redmine-cli` で検出。OS に応じたインストール方法を案内
- **プロファイル未設定**: `redmine-cli config list` で空を検出。インラインで config add フローを実行し、設定完了後に元のフローに継続
- **認証エラー・接続エラー**: 「Redmine への接続でエラーが発生しました。以下を確認してください: (1) プロファイルの URL が正しいか (2) API キーが有効か (3) Redmine サーバーが稼働しているか。`redmine-cli config list` でプロファイル設定を確認できます」と案内する
- **バリデーションエラー (422)**: Redmine からのエラーメッセージをそのまま表示し、修正を促す。よくある原因（件名が空、プロジェクトが無効等）を補足する
- **必須フラグ不足**: 件名またはプロジェクトが未指定の場合は再入力を求める
