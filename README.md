# claude-code

Claude Code 用のプラグイン集

## インストール方法

### 1. マーケットプレイスを登録

```bash
/plugin marketplace add chippy-ao/claude-code
```

### 2. プラグインをインストール

```bash
# law-studyプラグイン
/plugin install law-study@chippy-ao-plugins

# redmineプラグイン
/plugin install redmine@chippy-ao-plugins
```

### 3. 確認

```bash
/plugin
```

インストール済みプラグインの一覧に表示されていればOK。

## 利用可能なプラグイン

| プラグイン | 説明 |
|------------|------|
| [law-study](./law-study/) | e-Gov法令APIを活用した法令勉強支援。キーワード検索・要約・質問応答 |
| [redmine](./redmine/) | redmine-cli を活用したチケット検索・閲覧・分析・作成・関連付け支援。複数サーバー横断操作対応 |

## 使い方

### law-study

e-Gov法令APIを使った法令勉強支援。

```bash
# キーワードを指定して検索
/law 民法

# 引数なしで対話的に開始
/law
```

**フロー**:
1. キーワードを入力して法令を検索
2. 一覧から学習したい法令を選択
3. 法令の要約や質問応答で学習

詳細は [law-study/README.md](./law-study/README.md) を参照。

### redmine

redmine-cli を使ったチケット検索・閲覧・分析・作成・関連付け支援。

```text
# プロファイル設定
redmine:config

# キーワードを指定して検索
redmine:search ログイン機能のバグ

# チケット作成
redmine:create

# チケット関連付け
redmine:relation

# プロジェクト状況分析
redmine:analyze
```

**できること**:
- プロファイル管理（複数 Redmine サーバーの接続設定）
- チケット検索（キーワード、プロジェクト、ステータス、担当者等）
- チケット詳細・コメント履歴の表示
- チケット作成（対話的にプロジェクト選択・名称→ID解決）
- チケット関連付け（6種のリレーションタイプ対応）
- チケット分析（ステータス別集計、担当者負荷、期限切れ警告）

**前提条件**: [redmine-cli](https://github.com/chippy-ao/redmine-cli) のインストールが必要。

詳細は [redmine/README.md](./redmine/README.md) を参照。

## ライセンス

MIT
