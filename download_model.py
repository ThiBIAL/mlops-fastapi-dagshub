import mlflow

# Nom du modèle dans le Model Registry + "latest" = sa dernière version
MODEL_URI = "models:/digits-rf/latest"

# MLflow lit automatiquement ces variables d'environnement :
#   MLFLOW_TRACKING_URI       -> https://dagshub.com/ThiBial/MLFlow.mlflow
#   MLFLOW_TRACKING_USERNAME  -> ThiBial
#   MLFLOW_TRACKING_PASSWORD  -> ton token DagsHub
path = mlflow.artifacts.download_artifacts(artifact_uri=MODEL_URI, dst_path="model")

print(f"Model downloaded to {path}")
