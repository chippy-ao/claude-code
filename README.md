# claude-code

Claude Code 用のプラグイン集

## インストール方法

### 1. マーケットプレイスを登録

```bash
/plugin marketplace add chippy-ao/claude-code
```

### 2. プラグインをインストール

```bash
# planプラグイン
/plugin install plan@chippy-ao-plugins

# multi-agent-yakuzaプラグイン
/plugin install multi-agent-yakuza@chippy-ao-plugins
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
| [multi-agent-yakuza](./multi-agent-yakuza/) | Yakuza組織風の階層的マルチエージェントシステム。親父の命令を頭が受け取り、補佐がタスク分解、若いのと叔父貴が並列実行 |

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

### multi-agent-yakuza

Yakuza組織風のマルチエージェントシステム。

```bash
# 基本的な使用方法
ログイン機能を実装して

# 進捗確認
/yakuza:status
```

**特徴**:
- 完全縦型組織（親父 → 頭 → 補佐 → 若いの）
- 専門エージェント（叔父貴）の自動探索・活用
- 最大5人の若いの + 専門エージェントで並列実行
- 呼称ルール（親父、頭、兄貴、叔父貴、若いの）

詳細は [multi-agent-yakuza/README.md](./multi-agent-yakuza/README.md) を参照。

## ライセンス

MIT