FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

ENV MLFLOW_TRACKING_URI=https://dagshub.com/ThiBial/MLFlow.mlflow
ENV MLFLOW_TRACKING_USERNAME=ThiBial

COPY download_model.py .
RUN --mount=type=secret,id=dagshub_token \
    MLFLOW_TRACKING_PASSWORD=$(cat /run/secrets/dagshub_token) python download_model.py


COPY main.py .

EXPOSE 8000
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
