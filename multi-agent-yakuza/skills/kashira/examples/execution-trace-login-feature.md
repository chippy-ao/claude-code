# 実行トレース例：ログイン機能実装

このドキュメントは、ユーザーから「ログイン機能を実装して」と指示された場合の完全な実行フローを示します。

## 前提条件

- プロジェクト: `/Users/user/myapp/`
- 既存ファイル: `app.py`（Flask アプリ）
- 要求: ログイン機能の実装（認証API + フロントエンド）

---

## フェーズ1: 命令受領と確認

### ユーザー（親父）
```
ログイン機能を実装して
```

### 若頭（Kashira）の思考
1. 命令内容の理解:
   - タスク: ログイン機能の実装
   - 対象: `/Users/user/myapp/`
   - 不明点: 認証方式（JWT? セッション?）、UI 必要?

2. 不明点を確認する必要あり → AskUserQuestion

### 若頭（Kashira）のアクション
```python
AskUserQuestion(
    question="""親父、ログイン機能の実装について確認させてください：

1. 認証方式: JWT トークン or セッション？
2. フロントエンド: HTML/CSS/JS も必要？
3. データベース: SQLite? PostgreSQL?
4. パスワードのハッシュ化: bcrypt 使用でよろしいでしょうか？""",
    options=[
        "JWT + React フロントエンド + PostgreSQL",
        "セッション + HTMLテンプレート + SQLite",
        "認証のみ（UIは不要）"
    ]
)
```

### ユーザー（親父）の回答
```
セッション + HTMLテンプレート + SQLite でお願い
```

---

## フェーズ2: 補佐への指示と計画受領

### 若頭（Kashira）のアクション
```python
Task(
    subagent_type="multi-agent-yakuza:hosa",
    description="ログイン機能実装の計画立案",
    prompt="""
親父からの命令: セッションベースのログイン機能を実装

【目標】
- ユーザー認証機能（ログイン/ログアウト）
- セッション管理
- HTMLテンプレート（ログインフォーム）
- SQLite データベース（ユーザーテーブル）

【対象】
- プロジェクト: /Users/user/myapp/
- 既存ファイル: app.py

【制約】
- Flask-Login 使用
- bcrypt でパスワードハッシュ化
- SQLAlchemy で DB 操作

【実施内容】
1. 専門エージェント探索（必要に応じて）
2. タスクを1〜5個に分解
3. TaskCreate で各タスク作成
4. 適切なエージェント割り当て
5. 実行計画報告
    """
)
```

### 若頭（Kashira）の親父への報告
```
かしこまりました、親父。セッションベースのログイン機能を実装します。
補佐に計画を立案させます。進捗は /multi-agent-yakuza:status で確認可能です。
```

---

## フェーズ3: 補佐（Hosa）の計画立案

### 補佐（Hosa）の思考プロセス

1. **専門エージェント探索**
   ```python
   Grep(pattern="name:", path="/Users/user/.claude-plugins", output_mode="content")
   Read(file_path="/Users/user/.claude-plugins/code-review/plugin.json")
   ```
   結果: 専門エージェント「code-review」が利用可能

2. **タスク分解**
   - タスク1: データベースモデル作成（User テーブル）
   - タスク2: 認証ロジック実装（ログイン/ログアウト）
   - タスク3: HTML テンプレート作成（ログインフォーム）
   - タスク4: テスト作成
   - タスク5: コードレビュー（専門エージェント）

3. **エージェント割り当て**
   - タスク1〜4: 若いの（Wakashu）
   - タスク5: code-review

### 補佐（Hosa）のアクション
```python
# タスク1作成
TaskCreate(
    subject="データベースモデル作成",
    description="SQLAlchemy で User モデルを作成",
    assignee="multi-agent-yakuza:wakashu"
)
# task_id: "task_001" が返される

# タスク2作成
TaskCreate(
    subject="認証ロジック実装",
    description="Flask-Login で認証機能を実装",
    assignee="multi-agent-yakuza:wakashu"
)
# task_id: "task_002" が返される

# タスク3作成
TaskCreate(
    subject="HTML テンプレート作成",
    description="ログイン/ログアウトフォームを作成",
    assignee="multi-agent-yakuza:wakashu"
)
# task_id: "task_003" が返される

# タスク4作成
TaskCreate(
    subject="テスト作成",
    description="ログイン機能のユニットテストを作成",
    assignee="multi-agent-yakuza:wakashu"
)
# task_id: "task_004" が返される

# タスク5作成
TaskCreate(
    subject="コードレビュー",
    description="実装コードのレビューと改善提案",
    assignee="code-review:code-review"
)
# task_id: "task_005" が返される
```

### 補佐（Hosa）の若頭への報告
```
兄貴、実行計画を立案しました。

【タスク一覧】
1. task_001: データベースモデル作成（担当: 若いの）
2. task_002: 認証ロジック実装（担当: 若いの）
3. task_003: HTML テンプレート作成（担当: 若いの）
4. task_004: テスト作成（担当: 若いの）
5. task_005: コードレビュー（担当: code-review）

【実行指示】
- タスク1〜4は並列実行可能
- タスク5はタスク1〜4完了後に実行

全タスク作成完了。若頭の起動をお待ちしております。
```

---

## フェーズ4: エージェントの並列実行

### 若頭（Kashira）の親父への報告
```
親父、補佐から計画を受け取りました。5つのタスクに分割し、実行します。
```

### 若頭（Kashira）のアクション（並列実行）

```python
# ステップ1: タスク状態を in_progress に更新（若頭の責任）
TaskUpdate(task_id="task_001", status="in_progress")
TaskUpdate(task_id="task_002", status="in_progress")
TaskUpdate(task_id="task_003", status="in_progress")
TaskUpdate(task_id="task_004", status="in_progress")

# ステップ2: 若いの × 4人を並列起動
Task(
    subagent_type="multi-agent-yakuza:wakashu",
    description="データベースモデル作成",
    prompt="""
【任務】User モデル作成
【目標】SQLAlchemy で User テーブルを定義
【対象】/Users/user/myapp/models.py（新規作成）
【制約】
- フィールド: id, username, password_hash, email
- bcrypt でパスワードハッシュ化
- Flask-Login の UserMixin 継承
【期待される成果物】
- /Users/user/myapp/models.py 作成
    """
)

Task(
    subagent_type="multi-agent-yakuza:wakashu",
    description="認証ロジック実装",
    prompt="""
【任務】ログイン/ログアウト機能実装
【目標】Flask-Login で認証機能を実装
【対象】/Users/user/myapp/app.py（既存ファイル）
【制約】
- /login ルート（POST でログイン処理）
- /logout ルート（ログアウト処理）
- セッション管理
【期待される成果物】
- /Users/user/myapp/app.py 修正
    """
)

Task(
    subagent_type="multi-agent-yakuza:wakashu",
    description="HTML テンプレート作成",
    prompt="""
【任務】ログインフォーム作成
【目標】HTML/CSS でログインUIを作成
【対象】/Users/user/myapp/templates/login.html（新規作成）
【制約】
- Bootstrap 使用
- CSRF 対策（Flask-WTF）
【期待される成果物】
- /Users/user/myapp/templates/login.html 作成
    """
)

Task(
    subagent_type="multi-agent-yakuza:wakashu",
    description="テスト作成",
    prompt="""
【任務】ユニットテスト作成
【目標】pytest でログイン機能をテスト
【対象】/Users/user/myapp/tests/test_auth.py（新規作成）
【制約】
- 正常ログイン、失敗ログイン、ログアウトをテスト
- pytest-flask 使用
【期待される成果物】
- /Users/user/myapp/tests/test_auth.py 作成
    """
)
```

### 若頭（Kashira）の親父への報告
```
親父、全エージェント起動しました。作業中です。
```

---

## フェーズ5: 若いの（Wakashu）の実行

### 若いの1（models.py 作成）

#### 調査
```python
Read(file_path="/Users/user/myapp/app.py")  # 既存のコードスタイル確認
```

#### 実装
```python
Write(
    file_path="/Users/user/myapp/models.py",
    content="""
from flask_sqlalchemy import SQLAlchemy
from flask_login import UserMixin
from werkzeug.security import generate_password_hash, check_password_hash

db = SQLAlchemy()

class User(UserMixin, db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password_hash = db.Column(db.String(128), nullable=False)

    def set_password(self, password):
        self.password_hash = generate_password_hash(password)

    def check_password(self, password):
        return check_password_hash(self.password_hash, password)
    """
)
```

#### 報告
```
【任務完了報告】
【実施内容】User モデル作成
【成果物】
- /Users/user/myapp/models.py: 新規作成（User テーブル定義）
【テスト結果】構文エラーなし
【発生した問題】なし
```

### 若いの2（app.py 修正）

#### 調査
```python
Read(file_path="/Users/user/myapp/app.py")
```

#### 実装
```python
Edit(
    file_path="/Users/user/myapp/app.py",
    old_string="""from flask import Flask

app = Flask(__name__)""",
    new_string="""from flask import Flask, render_template, request, redirect, url_for
from flask_login import LoginManager, login_user, logout_user, login_required
from models import db, User

app = Flask(__name__)
app.config['SECRET_KEY'] = 'your-secret-key'
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///users.db'

db.init_app(app)
login_manager = LoginManager()
login_manager.init_app(app)

@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        user = User.query.filter_by(username=username).first()
        if user and user.check_password(password):
            login_user(user)
            return redirect(url_for('index'))
    return render_template('login.html')

@app.route('/logout')
@login_required
def logout():
    logout_user()
    return redirect(url_for('login'))"""
)
```

#### 報告
```
【任務完了報告】
【実施内容】ログイン/ログアウト機能実装
【成果物】
- /Users/user/myapp/app.py: 修正（認証ロジック追加）
【テスト結果】構文エラーなし
【発生した問題】なし
```

### 若いの3（login.html 作成）

#### 実装
```python
Write(
    file_path="/Users/user/myapp/templates/login.html",
    content="""
<!DOCTYPE html>
<html>
<head>
    <title>ログイン</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-5">
        <h2>ログイン</h2>
        <form method="POST">
            <div class="form-group">
                <label for="username">ユーザー名</label>
                <input type="text" class="form-control" id="username" name="username" required>
            </div>
            <div class="form-group">
                <label for="password">パスワード</label>
                <input type="password" class="form-control" id="password" name="password" required>
            </div>
            <button type="submit" class="btn btn-primary">ログイン</button>
        </form>
    </div>
</body>
</html>
    """
)
```

#### 報告
```
【任務完了報告】
【実施内容】ログインフォーム作成
【成果物】
- /Users/user/myapp/templates/login.html: 新規作成（ログインUI）
【テスト結果】HTML構文エラーなし
【発生した問題】なし
```

### 若いの4（test_auth.py 作成）

#### 実装
```python
Write(
    file_path="/Users/user/myapp/tests/test_auth.py",
    content="""
import pytest
from app import app, db
from models import User

@pytest.fixture
def client():
    app.config['TESTING'] = True
    app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///:memory:'
    with app.test_client() as client:
        with app.app_context():
            db.create_all()
        yield client

def test_login_success(client):
    # ユーザー作成
    user = User(username='test', email='test@example.com')
    user.set_password('password')
    db.session.add(user)
    db.session.commit()

    # ログイン
    response = client.post('/login', data={'username': 'test', 'password': 'password'})
    assert response.status_code == 302

def test_login_failure(client):
    response = client.post('/login', data={'username': 'invalid', 'password': 'wrong'})
    assert response.status_code == 200  # ログイン画面に戻る

def test_logout(client):
    response = client.get('/logout', follow_redirects=True)
    assert response.status_code == 200
    """
)
```

#### テスト実行
```bash
Bash(command="pytest /Users/user/myapp/tests/test_auth.py -v")
```

#### 報告
```
【任務完了報告】
【実施内容】ユニットテスト作成・実行
【成果物】
- /Users/user/myapp/tests/test_auth.py: 新規作成
【テスト結果】pytest: 3 passed
【発生した問題】なし
```

---

## フェーズ6: タスク完了とコードレビュー起動

### 若頭（Kashira）のアクション

```python
# ステップ1: タスク1〜4を completed に更新
TaskUpdate(task_id="task_001", status="completed")
TaskUpdate(task_id="task_002", status="completed")
TaskUpdate(task_id="task_003", status="completed")
TaskUpdate(task_id="task_004", status="completed")

# ステップ2: タスク5（コードレビュー）を in_progress に
TaskUpdate(task_id="task_005", status="in_progress")

# ステップ3: コードレビューエージェント起動
Task(
    subagent_type="code-review:code-review",
    description="ログイン機能のコードレビュー",
    prompt="""
以下のファイルをレビューしてください：
- /Users/user/myapp/models.py
- /Users/user/myapp/app.py
- /Users/user/myapp/templates/login.html
- /Users/user/myapp/tests/test_auth.py

【レビュー観点】
- セキュリティ（SQLインジェクション、CSRF）
- コード品質
- ベストプラクティス
    """
)
```

### 若頭（Kashira）の親父への報告
```
親父、若いの4人の作業が完了しました。
現在、コードレビューを実施中です。
```

---

## フェーズ7: コードレビューと完了報告

### code-review エージェントの応答
```
【レビュー結果】

【良い点】
✓ パスワードハッシュ化が適切
✓ テストカバレッジが十分
✓ SQLAlchemy の使い方が正しい

【改善提案】
1. CSRF 対策が不足（Flask-WTF 未使用）
2. SECRET_KEY がハードコード（環境変数推奨）
3. エラーハンドリングが不足

【推奨修正】
- Flask-WTF で CSRF トークン追加
- .env ファイルで SECRET_KEY 管理
```

### 若頭（Kashira）のアクション
```python
# コードレビュータスクを completed に
TaskUpdate(task_id="task_005", status="completed")
```

### 若頭（Kashira）の親父への最終報告
```
親父、全作業が完了しました。

【実施内容】
1. データベースモデル作成 ✓
2. 認証ロジック実装 ✓
3. HTML テンプレート作成 ✓
4. テスト作成・実行（3 passed）✓
5. コードレビュー完了 ✓

【成果物】
- /Users/user/myapp/models.py: 新規作成（User モデル）
- /Users/user/myapp/app.py: 修正（ログイン/ログアウト機能追加）
- /Users/user/myapp/templates/login.html: 新規作成（ログインUI）
- /Users/user/myapp/tests/test_auth.py: 新規作成（テスト）

【コードレビュー結果】
- 基本実装は問題なし
- 改善提案: CSRF対策、SECRET_KEY管理、エラーハンドリング
  （必要に応じて追加実装いたします）

詳細は /multi-agent-yakuza:status で確認可能です。
問題なく完了しております。
```

---

## まとめ

### 若頭（Kashira）の主要な役割

1. **命令受領と確認**: 不明点を AskUserQuestion で確認
2. **補佐への指示**: Task() で補佐を起動し、計画を受領
3. **並列実行**: 補佐の計画を元に、自分でエージェントを並列起動
4. **タスク状態管理**: TaskUpdate で in_progress/completed を更新（若頭の責任）
5. **進捗報告**: 親父に随時状況を報告
6. **完了報告**: 全タスク完了後、成果を明確に報告

### 成功のポイント

- ✅ 命令が不明確な場合は必ず AskUserQuestion で確認
- ✅ 補佐に具体的な指示を出し、計画を受領
- ✅ エージェント起動前に TaskUpdate(in_progress) を実行
- ✅ 並列実行可能なタスクは同時に起動
- ✅ 完了後は TaskUpdate(completed) を実行
- ✅ 親父への報告を怠らない
- ✅ 階層構造を守る（若いのと直接やり取りしない）
