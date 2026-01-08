# claude-code

Claude Code 用のプラグイン集

## インストール方法

### 1. マーケットプレイスを登録

```bash
/plugin marketplace add chippy-ao/claude-code
```

### 2. プラグインをインストール

```bash
/plugin install plan@chippy-ao-plugins
```

### 3. 確認

```bash
/plugin
```

インストール済みプラグインの一覧に表示されていればOK。

## 利用可能なプラグイン

| プラグイン | 説明 |
|------------|------|
| [plan](./plan/) | 質問で要件を深掘りしてからプランニングする |

## 使い方

### plan:digging

```bash
# 相談内容を引数で指定
/plan:digging ログイン機能を追加したい

# 引数なしで対話的に開始
/plan:digging
```

詳細は [plan/README.md](./plan/README.md) を参照。

## ライセンス

MIT
