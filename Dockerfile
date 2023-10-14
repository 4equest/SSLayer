# ベースイメージとして公式のPythonイメージを使用
FROM python:3.10-slim-buster AS backend

# ワーキングディレクトリを設定
WORKDIR /app

# 必要なパッケージをインストール
COPY backend/requirements.txt .
RUN pip install -r requirements.txt

# FastAPIアプリケーションをコピー
COPY backend/main.py .

# ベースイメージとして公式のNode.jsイメージを使用
FROM node:18.18.1 AS frontend

# ワーキングディレクトリを設定
WORKDIR /app

# 必要なパッケージをインストール
COPY frontend/package.json frontend/package-lock.json ./
RUN npm ci

# TypeScriptアプリケーションをコピー
COPY frontend/index.ts .

# TypeScriptをJavaScriptにコンパイル
RUN npx tsc index.ts

# マルチステージビルド：バックエンドとフロントエンドのイメージを結合
FROM backend AS final

# フロントエンドのビルド成果物をコピー
COPY --from=frontend /app/index.js ./frontend/

# アプリケーションを実行するコマンドを設定（FastAPI）
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
