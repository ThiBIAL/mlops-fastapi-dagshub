FROM python:3.11-slim

WORKDIR /app

# 1. Dépendances (couche mise en cache tant que requirements.txt ne change pas)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 2. Infos de connexion à DagsHub (pas secrètes)
ENV MLFLOW_TRACKING_URI=https://dagshub.com/ThiBial/MLFlow.mlflow
ENV MLFLOW_TRACKING_USERNAME=ThiBial

# 3. Téléchargement du dernier modèle, avec le token passé en secret
COPY download_model.py .
RUN --mount=type=secret,id=dagshub_token \
    MLFLOW_TRACKING_PASSWORD=$(cat /run/secrets/dagshub_token) python download_model.py

# 4. Code de l'API
COPY main.py .

EXPOSE 8000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
