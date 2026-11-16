import mlflow.pyfunc
import numpy as np
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

# Chargé une seule fois au démarrage, depuis le dossier téléchargé par download_model.py
model = mlflow.pyfunc.load_model("model")

app = FastAPI(title="Digits classifier")


class PredictRequest(BaseModel):
    features: list[float]  # 64 valeurs (image 8x8 aplatie, pixels entre 0 et 16)


@app.post("/predict")
def predict(req: PredictRequest):
    if len(req.features) != 64:
        raise HTTPException(status_code=422, detail="features must contain exactly 64 values")
    prediction = model.predict(np.array([req.features]))
    return {"prediction": int(prediction[0])}
