# redmine

redmine-cli を活用したチケット検索・閲覧・分析支援プラグイン。
複数の Redmine サーバーをプロファイルで横断操作できる。

## 前提条件

- [redmine-cli](https://github.com/chippy-ao/redmine-cli) がインストールされていること
- Redmine 5.1.0 以上のサーバーにアクセス可能であること
- Redmine REST API キーを取得済みであること

### redmine-cli のインストール

**macOS (Homebrew):**

```bash
brew install chippy-ao/tap/redmine-cli
```

**Windows:**

1. [GitHub Releases](https://github.com/chippy-ao/redmine-cli/releases) から ZIP をダウンロード
2. ZIP を展開し、`redmine-cli.exe` を任意のフォルダに配置（例: `C:\tools\redmine-cli\`）
3. PATH を設定して、どこからでも `redmine-cli` コマンドを実行できるようにする:
   - `Win + R` →「`sysdm.cpl`」を実行 →「詳細設定」タブ →「環境変数」
   - ユーザー環境変数の `Path` を選んで「編集」→「新規」
   - `redmine-cli.exe` を配置したフォルダのパスを追加（例: `C:\tools\redmine-cli`）
   - 「OK」で閉じる
4. **ターミナルを再起動**して PATH を反映:
   - コマンドプロンプトや PowerShell を**一度閉じて開き直す**
   - Claude Code を使っている場合は、**Claude Code を起動しているターミナルも再起動**が必要（Claude Code はターミナルの環境変数を継承するため）
5. 動作確認:

```powershell
redmine-cli --version
```

バージョンが表示されれば OK。Claude Code 上でも同様に認識される。

**go install:**

```bash
go install github.com/chippy-ao/redmine-cli@latest
```

## プラグインのインストール

```bash
/plugin install redmine@chippy-ao-plugins
```

## セットアップ

プロファイルを対話的に設定:

```text
redmine:config
```

または CLI で直接設定:

```bash
redmine-cli config add work --url https://redmine.example.com --api-key YOUR_API_KEY
```

## 使い方

### チケット検索

```text
redmine:search ログイン機能のバグ
```

または引数なしで対話的に開始:

```text
redmine:search
```

### チケット作成

```text
redmine:create
```

または具体的に:

```text
redmine:create ログイン画面のバグ修正チケットを作って
```

作成前に類似チケットの重複チェックが自動で実行される。表現揺れを含む複数キーワードで検索し、意味的に類似するチケットがあれば候補を表示して確認を促す。

### チケット関連付け

```text
redmine:relation
```

チケット間のリレーション（関連・ブロック・先行/後続等）を対話的に追加・削除できる。

### チケット更新・削除・コメント

```text
redmine:update
```

または具体的に:

```text
redmine:update チケット#123のステータスを完了にして
redmine:update チケット#456にコメントを追加
redmine:update チケット#789を削除
```

### チケット一括作成

```text
redmine:batch-create
```

または具体的に:

```text
redmine:batch-create tickets.yml からチケットを一括作成して
```

フリーフォーマット（txt/md/yaml等）のファイルからチケット情報を読み取り、一括作成する。親子チケットの階層構造にも対応。

### プロジェクト状況分析

```text
redmine:analyze
```

### プロファイル管理

```text
redmine:config
```

## 機能一覧

| スキル | 説明 |
|--------|------|
| `redmine:config` | プロファイルの追加・一覧・デフォルト変更・削除 |
| `redmine:search` | キーワード・プロジェクト・ステータス・担当者等でチケット検索、詳細表示 |
| `redmine:create` | 対話的にチケットを作成（プロジェクト選択・名称→ID解決・重複チェック付き） |
| `redmine:batch-create` | ファイルからチケット情報を読み込み一括作成（フリーフォーマット対応・親子階層対応） |
| `redmine:relation` | チケット間のリレーション追加・削除（6種の関連タイプ対応） |
| `redmine:update` | チケットの更新・削除・コメント記入（名称→ID解決・確認フロー付き） |
| `redmine:analyze` | ステータス別集計、担当者負荷、期限切れ警告、優先度分布 |

## 複数の Redmine サーバーを使う

プロファイルを複数登録して切り替え:

```bash
redmine-cli config add work --url https://redmine-work.example.com --api-key KEY1
redmine-cli config add oss --url https://redmine-oss.example.com --api-key KEY2
redmine-cli config set-default work
```

`redmine:search` や `redmine:analyze` 起動時に、使用するプロファイルを選択できる。
複数プロファイルを同時に選択して横断検索することも可能。

## 制約

- チケットのカスタムフィールド操作は未対応
- 1リクエストあたり最大 100 件の取得制限

## ライセンス

MIT
