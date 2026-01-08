# plan-with-questions

質問で要件を深掘りしてからプランニングするClaude Codeプラグイン。

## 概要

曖昧な要件から始まるタスクに対して、`AskUserQuestion`ツールを使って対話的に要件を明確化し、整理した内容をプランとして出力します。

## 機能

- 3-5問程度の質問で要件を深掘り
- ユーザーとの合意が取れるまで質問を繰り返し
- 出力形式を選択可能（tmpファイル or Claude Code Planモード）
- 必要に応じてWeb検索で最新情報を取得

## 使い方

```bash
# 相談内容を引数で指定
/plan-with-questions ログイン機能を追加したい

# 引数なしで実行（対話的に相談内容を聞く）
/plan-with-questions
```

## インストール

```bash
claude --plugin-dir /path/to/plan-with-questions
```

## ライセンス

MIT
