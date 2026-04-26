"""
CareerShield AI - Prediction Module
Loads a saved model when available and falls back to rules for local bring-up.
"""

import pickle
import re
from pathlib import Path


BASE_DIR = Path(__file__).resolve().parent
MODEL_PATH = BASE_DIR / "model.pkl"
VECTORIZER_PATH = BASE_DIR / "vectorizer.pkl"

MODEL = None
VECTORIZER = None
MODEL_READY = False


def _load_artifacts() -> None:
    global MODEL, VECTORIZER, MODEL_READY

    if not MODEL_PATH.exists() or not VECTORIZER_PATH.exists():
        print("ML artifacts not found. Using fallback heuristic scoring.")
        MODEL_READY = False
        return

    print("Loading ML model...")
    with open(MODEL_PATH, "rb") as f:
        MODEL = pickle.load(f)

    with open(VECTORIZER_PATH, "rb") as f:
        VECTORIZER = pickle.load(f)

    MODEL_READY = True
    print("ML model loaded successfully.")


_load_artifacts()


def clean_text(text: str) -> str:
    """Clean and normalize input text."""
    text = text.lower()
    text = re.sub(r"[^a-zA-Z0-9\s]", "", text)
    text = re.sub(r"\s+", " ", text)
    return text.strip()


def _fallback_predict(job_text: str) -> dict:
    """Use simple heuristics until the trained model is generated."""
    cleaned = clean_text(job_text)
    signals = [
        ("registration fee", 28),
        ("upfront payment", 25),
        ("whatsapp", 18),
        ("no experience", 12),
        ("work from home", 10),
        ("urgent hiring", 12),
        ("guaranteed income", 22),
        ("easy money", 22),
        ("bank account", 20),
        ("pay rs", 20),
    ]

    score = 8
    for phrase, weight in signals:
        if phrase in cleaned:
            score += weight

    if re.search(r"(earn|salary).*(50,?000|50000|100000)", cleaned):
        score += 16

    risk_score = min(float(score), 99.0)
    return {
        "risk_score": round(risk_score, 2),
        "is_scam": risk_score >= 50,
        "confidence": 55.0 if risk_score < 50 else 72.0,
        "model_source": "fallback",
    }


def predict_scam(job_text: str) -> dict:
    """Predict if a job posting is fake."""
    if not job_text or len(job_text.strip()) < 10:
        return {
            "risk_score": 0,
            "is_scam": False,
            "confidence": 0,
            "error": "Text too short to analyze",
        }

    if not MODEL_READY:
        return _fallback_predict(job_text)

    cleaned = clean_text(job_text)
    vectorized = VECTORIZER.transform([cleaned])

    prediction = MODEL.predict(vectorized)[0]
    probabilities = MODEL.predict_proba(vectorized)[0]

    scam_probability = probabilities[1]
    risk_score = round(scam_probability * 100, 2)

    return {
        "risk_score": risk_score,
        "is_scam": bool(prediction == 1),
        "confidence": round(max(probabilities) * 100, 2),
        "model_source": "trained",
    }


if __name__ == "__main__":
    test_text = """
    Urgent Hiring! Work from home.
    Earn Rs 50,000 per month.
    No experience needed.
    Pay Rs 2000 registration fee to start.
    Contact WhatsApp only.
    """

    result = predict_scam(test_text)
    print(f"Risk Score: {result['risk_score']}%")
    print(f"Is Scam: {result['is_scam']}")
    print(f"Confidence: {result['confidence']}%")
