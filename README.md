# claude-code

Claude Code 用のプラグイン集

## インストール方法

### 1. マーケットプレイスを登録

```bash
/plugin marketplace add chippy-ao/claude-code
```

### 2. プラグインをインストール

```bash
/plugin install plan-with-questions@chippy-ao-plugins
```

### 3. 確認

```bash
/plugin
```

インストール済みプラグインの一覧に表示されていればOK。

## 利用可能なプラグイン

| プラグイン | 説明 |
|------------|------|
| [plan-with-questions](./plan-with-questions/) | 質問で要件を深掘りしてからプランニングする |

## 使い方

### plan-with-questions

```bash
# 相談内容を引数で指定
/plan-with-questions ログイン機能を追加したい

# 引数なしで対話的に開始
/plan-with-questions
```

詳細は [plan-with-questions/README.md](./plan-with-questions/README.md) を参照。

## ライセンス

MIT