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
| [plan](./plan/) | 質問で要件を深掘りしてからプランニングするスキルと hook を提供 |

## 使い方

### plan:digging スキル

要件を深掘りして計画を立案する。

```bash
# 相談内容を引数で指定
/plan:dig ログイン機能を追加したい

# 引数なしで対話的に開始
/plan:dig
```

**トリガーフレーズ**（自動でスキルが起動）:
- 「要件を整理して」
- 「プランを立てて」
- 「計画を作って」

### plan-reminder hook

セッション開始時に未完了の計画を通知する。

詳細は [plan/README.md](./plan/README.md) を参照。

## ライセンス

MIT