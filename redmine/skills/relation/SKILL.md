---
description: Redmineチケット関連付けスキル。redmine-cli を使ってチケット間のリレーションを作成・削除する。「redmine:relation」「チケットを関連付けて」「リレーション追加」「紐付け」で起動。
---

# Redmine チケット関連付け

redmine-cli を使って、チケット間のリレーション（関連・ブロック・先行/後続等）を管理する。

## 利用する CLI コマンド

すべてのコマンドは JSON を stdout に出力する。Bash ツールで実行し、出力をパースして整形表示する。

- `redmine-cli add-relation` — リレーション作成
- `redmine-cli delete-relation` — リレーション削除
- `redmine-cli get-issue <id> --include relations` — 現在のリレーション確認
- `redmine-cli config list` — プロファイル一覧取得

すべてのコマンドに `--profile <name>` を付与してプロファイルを指定する（デフォルトプロファイル使用時は省略可）。

## 大前提

- **確認必須**: リレーション作成・削除前に必ずユーザーに確認する
- **1回1リレーション**: 1回の操作で1リレーションのみ作成・削除する
- リレーション一覧の確認は `get-issue --include relations` で行う

## リレーション種別

| 種別 | 説明 | 自動で付く逆方向 |
|------|------|-----------------|
| `relates` | 関連 | relates |
| `duplicates` | 重複 | duplicated |
| `blocks` | ブロック | blocked |
| `precedes` | 先行 | follows |
| `follows` | 後続 | precedes |
| `copied_to` | コピー先 | copied_from |

`precedes` と `follows` のみ `--delay` (遅延日数) を指定可能。

## フロー

### -1. 前提チェック

1. `which redmine-cli` で CLI がインストールされているか確認する
2. **未インストールの場合**、以下を案内して終了する:
   - macOS: `brew install chippy-ao/tap/redmine-cli`
   - Windows: [README の Windows セクション](../../README.md) を参照（ZIP 展開 → PATH 設定 → ターミナル再起動）
   - その他: `go install github.com/chippy-ao/redmine-cli@latest`

### 0. プロファイル選択

`redmine-cli config list` を実行してプロファイルを確認する。

- **0件**: プロファイル未設定を伝え、AskUserQuestion で設定フローに入る
- **1件**: そのプロファイルを使用する旨を伝え、次のステップに進む
- **複数**: AskUserQuestion で使用するプロファイルを選択

### 1. 対象チケット確認

ユーザーが指定したチケット番号で `redmine-cli get-issue <id> --include relations --profile <p>` を実行し、以下を表示する:

- **基本情報**: チケットID、件名、ステータス
- **既存リレーション**: 現在のリレーション一覧（種別・相手チケットID・件名）
  - リレーションがない場合は「リレーションはありません」と表示

### 2. 操作選択

AskUserQuestion で以下を選択:

- **リレーションを追加する**: 新しいリレーションを作成
- **リレーションを削除する**: 既存のリレーションを削除（既存リレーションがある場合のみ）

### 3a. リレーション追加

1. **関連先チケット番号**: ユーザーに入力してもらう。入力されたら `get-issue` で存在確認し、件名を表示する
2. **リレーション種別**: AskUserQuestion で選択（日本語の説明付き）
   - 「関連」(relates) / 「重複」(duplicates) / 「ブロック」(blocks) / 「先行」(precedes) / 「後続」(follows) / 「コピー先」(copied_to)
3. **遅延日数**: precedes/follows が選ばれた場合のみ、遅延日数を確認（デフォルト: なし）
4. **確認プロンプト**: 「チケット #X と #Y を『種別名』で関連付けます。よろしいですか？」
5. 実行:

```bash
redmine-cli add-relation --profile <p> --issue-id X --related-id Y --type TYPE [--delay N]
```

### 3b. リレーション削除

1. 現在のリレーション一覧から削除対象を AskUserQuestion で選択
2. **確認プロンプト**: 「リレーション #ID（チケット #X → #Y: 種別名）を削除します。よろしいですか？」
3. 実行:

```bash
redmine-cli delete-relation --profile <p> RELATION_ID
```

### 4. 結果表示と次のアクション

操作結果を表示し、次のアクションを**平易な言葉**で提案する:

- **別のリレーションを追加する**: 同じチケットに別のリレーションを追加
- **チケット詳細を確認する**: `get-issue --include relations` で最新状態を確認
- **新規チケットを作成する**: `redmine:create` スキルへ案内
- **検索に戻る**: `redmine:search` スキルへ案内

## エラーハンドリング

- **CLI 未インストール**: `which redmine-cli` で検出。OS に応じたインストール方法を案内
- **プロファイル未設定**: search スキルと同じフロー
- **認証エラー・接続エラー**: search スキルと同じ案内
- **バリデーションエラー (422)**: Redmine からのエラーメッセージを表示。よくある原因（同じチケット同士、既に同じリレーションが存在等）を補足する
- **リレーション種別の入力ミス**: 有効な種別リストを提示して再入力を促す
- **チケットが見つからない (404)**: 「チケット #X が見つかりません」と表示し、番号の確認を促す
