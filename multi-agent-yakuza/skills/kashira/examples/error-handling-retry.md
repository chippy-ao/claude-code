# 実行トレース例：エラー発生とリトライ

このドキュメントは、若いのからエラーが返され、若頭がリトライする実例を示します。

## 前提条件

- プロジェクト: `/Users/user/webapp/`
- タスク: API エンドポイント追加
- エラー: ファイルパス間違いで若いのが失敗

---

## フェーズ1: 初回実行とエラー発生

### ユーザー（親父）
```
/api/users エンドポイントを追加して
```

### 若頭（Kashira）のアクション
```python
# 補佐起動（計画立案）
Task(
    subagent_type="multi-agent-yakuza:hosa",
    description="API エンドポイント追加の計画立案",
    prompt="""
親父からの命令: /api/users エンドポイント追加

【目標】ユーザー一覧を返す API エンドポイント作成
【対象】/Users/user/webapp/
【制約】Flask 使用、JSON 形式で返す
    """
)
```

### 補佐（Hosa）の応答
```
【実行計画】
タスク1（task_101）: /api/users エンドポイント実装（担当: 若いの）
タスク2（task_102）: テスト作成（担当: 若いの）
```

### 若頭（Kashira）のアクション（並列実行）
```python
# タスク状態を in_progress に
TaskUpdate(task_id="task_101", status="in_progress")
TaskUpdate(task_id="task_102", status="in_progress")

# 若いの × 2人を並列起動
Task(
    subagent_type="multi-agent-yakuza:wakashu",
    description="API エンドポイント実装",
    prompt="""
【任務】/api/users エンドポイント作成
【目標】ユーザー一覧を JSON で返す
【対象】/Users/user/webapp/app.py（既存ファイル）
【制約】Flask 使用
【期待される成果物】/Users/user/webapp/app.py 修正
    """
)

Task(
    subagent_type="multi-agent-yakuza:wakashu",
    description="テスト作成",
    prompt="""
【任務】/api/users のテスト作成
【目標】pytest でエンドポイントをテスト
【対象】/Users/user/webapp/tests/test_api.py（新規作成）
【期待される成果物】/Users/user/webapp/tests/test_api.py 作成
    """
)
```

---

## フェーズ2: エラー発生

### 若いの1（app.py 修正担当）の応答
```
【任務完了報告】
【実施内容】/api/users エンドポイント実装試行
【成果物】なし
【発生した問題】
ファイル /Users/user/webapp/app.py が見つかりません。
調査結果: 正しいパスは /Users/user/webapp/src/app.py でした。

補佐のご判断をお願いします。
```

### 若いの2（test_api.py 作成担当）の応答
```
【任務完了報告】
【実施内容】テスト作成
【成果物】
- /Users/user/webapp/tests/test_api.py: 新規作成
【テスト結果】テスト実行不可（app.py が修正されていないため）
【発生した問題】なし（ただし app.py 修正後に再テスト必要）
```

---

## フェーズ3: 若頭のエラー分析

### 若頭（Kashira）の思考
```
【エラー分析】
- 若いの1: ファイルパスが間違っていた（app.py → src/app.py）
- 若いの2: テスト作成は成功（ただし app.py 修正待ち）

【対処法】
1. タスク101を failed に更新
2. 正しいパスで若いの1を再起動
3. タスク102は保留（app.py 修正後に再テスト）
```

### 若頭（Kashira）のアクション
```python
# タスク101を failed に更新
TaskUpdate(task_id="task_101", status="failed")

# タスク102は in_progress のまま保留（再テスト予定）
```

### 若頭（Kashira）の親父への報告
```
親父、問題が発生しました。

【問題】ファイルパスの誤り（app.py → src/app.py）
【状況】
- タスク1（エンドポイント実装）: 失敗
- タスク2（テスト作成）: 成功（ただし再テスト必要）

【対応】正しいパスで若いのを再起動します。
```

---

## フェーズ4: リトライ実行

### 若頭（Kashira）のアクション（リトライ）

```python
# 新しいタスク作成（正しいパス）
TaskCreate(
    subject="API エンドポイント実装（リトライ）",
    description="/api/users エンドポイント作成（正しいパス）",
    assignee="multi-agent-yakuza:wakashu"
)
# task_id: "task_103" が返される

# タスク103を in_progress に
TaskUpdate(task_id="task_103", status="in_progress")

# 若いの再起動（正しいパス）
Task(
    subagent_type="multi-agent-yakuza:wakashu",
    description="API エンドポイント実装（リトライ）",
    prompt="""
【任務】/api/users エンドポイント作成
【目標】ユーザー一覧を JSON で返す
【対象】/Users/user/webapp/src/app.py（正しいパス）
【制約】Flask 使用
【期待される成果物】/Users/user/webapp/src/app.py 修正
    """
)
```

### 若頭（Kashira）の親父への報告
```
親父、正しいパスで若いのを再起動しました。作業中です。
```

---

## フェーズ5: リトライ成功

### 若いの1（リトライ実行）の応答
```
【任務完了報告】
【実施内容】/api/users エンドポイント実装
【成果物】
- /Users/user/webapp/src/app.py: 修正（エンドポイント追加）
【テスト結果】構文エラーなし
【発生した問題】なし
```

### 若頭（Kashira）のアクション
```python
# タスク103を completed に
TaskUpdate(task_id="task_103", status="completed")

# タスク102（テスト）を再実行
Task(
    subagent_type="multi-agent-yakuza:wakashu",
    description="テスト再実行",
    prompt="""
【任務】/api/users のテスト再実行
【目標】pytest でエンドポイントをテスト
【対象】/Users/user/webapp/tests/test_api.py（既存ファイル）
【期待される成果物】テスト実行結果
    """
)
```

### 若いの2（テスト再実行）の応答
```
【任務完了報告】
【実施内容】テスト再実行
【成果物】
- /Users/user/webapp/tests/test_api.py: テスト実行
【テスト結果】pytest: 1 passed
【発生した問題】なし
```

### 若頭（Kashira）のアクション
```python
# タスク102を completed に
TaskUpdate(task_id="task_102", status="completed")
```

---

## フェーズ6: 完了報告

### 若頭（Kashira）の親父への最終報告
```
親父、全作業が完了しました。

【実施内容】
1. /api/users エンドポイント実装 ✓（リトライ1回）
2. テスト作成・実行（1 passed）✓

【成果物】
- /Users/user/webapp/src/app.py: 修正（エンドポイント追加）
- /Users/user/webapp/tests/test_api.py: 新規作成（テスト）

【発生した問題と対応】
- ファイルパス誤り（app.py → src/app.py）→ 正しいパスで再実行し成功

詳細は /multi-agent-yakuza:status で確認可能です。
問題なく完了しております。
```

---

## まとめ：エラー対応フロー

### 1. エラー検知
- 若いのからエラー応答を受け取る
- TaskOutput で詳細を確認（必要に応じて）

### 2. エラー分析
```
【分析項目】
- 何が失敗したか？
- 原因は何か？（ファイルパス、依存不足、構文エラーなど）
- 自動リトライ可能か？
- 親父の判断が必要か？
```

### 3. 対処法の決定

#### ケースA: 自動リトライ可能
```python
# 失敗タスクを failed に更新
TaskUpdate(task_id="failed_task_id", status="failed")

# 新しいタスク作成（修正内容反映）
TaskCreate(subject="リトライ", description="...", assignee="...")

# 若いの再起動
Task(subagent_type="multi-agent-yakuza:wakashu", ...)
```

#### ケースB: 親父の判断が必要
```
親父、問題が発生しました。
【問題】[エラー内容]
【状況】完了: [タスク]、失敗: [タスク]
【対処法の選択肢】
1. [方法1]
2. [方法2]
ご指示をお願いいたします。
```

### 4. リトライ実行
- 修正した指示で若いのを再起動
- 成功したら completed に更新

### 5. 完了報告
- 親父に最終結果を報告
- エラーと対応内容も記載

---

## 自動リトライ可能な例

### ✅ リトライ可能
- ファイルパスの誤り（正しいパスが判明済み）
- 軽微な構文エラー（修正方法が明確）
- 依存パッケージ不足（インストールで解決）
- テスト失敗（コード修正で解決可能）

### ❌ 親父の判断が必要
- 要件の解釈が不明（AskUserQuestion で確認）
- 複数の修正方法があり、選択が必要
- セキュリティリスクがある変更
- 破壊的な変更（データ削除など）

---

## タスク状態の推移（正常ケース）

```
todo → in_progress → completed
```

## タスク状態の推移（エラー→リトライ）

```
todo → in_progress → failed → （新タスク作成）→ todo → in_progress → completed
```

**重要**: 若頭だけが TaskUpdate ツールを持つため、タスク状態管理は若頭の責任です。
