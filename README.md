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

## ライセンス

MIT
