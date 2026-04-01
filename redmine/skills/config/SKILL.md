---
description: Redmine CLI のプロファイル管理スキル。接続先の追加・一覧・デフォルト設定・削除を対話的に行う。「redmine:config」「Redmineの接続設定」「プロファイル追加」「Redmine設定」で起動。
---

# Redmine プロファイル管理

redmine-cli のプロファイル（Redmine サーバーの URL と API キー）を対話的に管理する。

## 前提チェック

1. `which redmine-cli` で CLI がインストールされているか確認する
2. **未インストールの場合**、以下を案内して終了する:
   - macOS: `brew install chippy-ao/tap/redmine-cli`
   - Windows: [README の Windows セクション](../../README.md) を参照（ZIP 展開 → PATH 設定 → ターミナル再起動）
   - その他: `go install github.com/chippy-ao/redmine-cli@latest`

## フロー

### 1. 現在の状態を表示

`redmine-cli config list` を実行して、現在のプロファイル一覧を表示する。

- プロファイルがある場合: 名前・URL・デフォルトかどうかを一覧表示
- プロファイルがない場合: 「プロファイルが未設定です」と表示

### 2. 操作の選択

ユーザーの意図に応じて操作する。意図が明確でない場合は AskUserQuestion で以下の選択肢を提示:

- **追加**: 新しいプロファイルを追加
- **一覧**: 現在のプロファイルを確認（既に表示済みなら省略）
- **デフォルト変更**: デフォルトプロファイルを切り替え
- **削除**: プロファイルを削除

### 3. 各操作の実行

#### 追加 (add)

1. AskUserQuestion でプロファイル名を聞く（例: work, oss, staging）
2. AskUserQuestion で Redmine の URL を聞く
3. AskUserQuestion で API キーを聞く
4. `redmine-cli config add <name> --url <url> --api-key <key>` を実行
5. 成功したら `redmine-cli config list` で結果を表示

#### デフォルト変更 (set-default)

1. `redmine-cli config list` で一覧取得
2. AskUserQuestion でプロファイル名を選んでもらう
3. `redmine-cli config set-default <name>` を実行

#### 削除 (remove)

1. `redmine-cli config list` で一覧取得
2. AskUserQuestion でプロファイル名を選んでもらう
3. AskUserQuestion で「本当に削除しますか？」と確認
4. 確認後 `redmine-cli config remove <name>` を実行

### 4. 続けて操作するか確認

操作完了後、「他に設定変更はありますか？」と確認する。
