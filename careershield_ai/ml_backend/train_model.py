"""
CareerShield AI - Model Training Script
Dataset: Fake Job Postings (Kaggle)
Download from: kaggle.com/datasets/amruthjithp/
               fraudulent-job-postings-dataset
"""

import pickle
from pathlib import Path

import pandas as pd
from sklearn.ensemble import RandomForestClassifier
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics import (
    accuracy_score,
    classification_report,
    f1_score,
    precision_score,
    recall_score,
)
from sklearn.model_selection import train_test_split


def load_and_clean_data(filepath):
    """Load and preprocess fake job postings dataset."""
    print("Loading dataset...")
    df = pd.read_csv(filepath)

    print(f"Total records: {len(df)}")
    print(f"Fake jobs: {df['fraudulent'].sum()}")
    print(f"Real jobs: {len(df) - df['fraudulent'].sum()}")

    text_columns = [
        "title",
        "company_profile",
        "description",
        "requirements",
        "benefits",
    ]

    for col in text_columns:
        if col in df.columns:
            df[col] = df[col].fillna("")

    df["combined_text"] = (
        df["title"]
        + " "
        + df["company_profile"]
        + " "
        + df["description"]
        + " "
        + df["requirements"]
        + " "
        + df["benefits"]
    )

    df["combined_text"] = (
        df["combined_text"]
        .str.lower()
        .str.replace(r"[^a-zA-Z0-9\s]", "", regex=True)
        .str.strip()
    )

    df = df[df["combined_text"].str.len() > 10]

    print(f"Clean records: {len(df)}")
    return df


def train_model(df):
    """Train TF-IDF + Random Forest classifier."""
    print("\nTraining model...")

    X = df["combined_text"]
    y = df["fraudulent"]

    X_train, X_test, y_train, y_test = train_test_split(
        X,
        y,
        test_size=0.2,
        random_state=42,
        stratify=y,
    )

    vectorizer = TfidfVectorizer(
        max_features=10000,
        ngram_range=(1, 2),
        stop_words="english",
        min_df=2,
    )

    X_train_vec = vectorizer.fit_transform(X_train)
    X_test_vec = vectorizer.transform(X_test)

    model = RandomForestClassifier(
        n_estimators=200,
        max_depth=20,
        min_samples_split=5,
        random_state=42,
        class_weight="balanced",
        n_jobs=-1,
    )

    model.fit(X_train_vec, y_train)
    y_pred = model.predict(X_test_vec)

    print("\n=== MODEL PERFORMANCE ===")
    print(f"Accuracy:  {accuracy_score(y_test, y_pred):.4f}")
    print(f"Precision: {precision_score(y_test, y_pred):.4f}")
    print(f"Recall:    {recall_score(y_test, y_pred):.4f}")
    print(f"F1 Score:  {f1_score(y_test, y_pred):.4f}")
    print("\nDetailed Report:")
    print(classification_report(y_test, y_pred))

    return model, vectorizer


def save_model(model, vectorizer):
    """Save trained model and vectorizer."""
    print("\nSaving model...")

    with open(BASE_DIR / "model.pkl", "wb") as f:
        pickle.dump(model, f)

    with open(BASE_DIR / "vectorizer.pkl", "wb") as f:
        pickle.dump(vectorizer, f)

    print("Model saved as: model.pkl")
    print("Vectorizer saved as: vectorizer.pkl")


if __name__ == "__main__":
    DATASET_PATH = BASE_DIR / "fake_job_postings.csv"

    dataframe = load_and_clean_data(DATASET_PATH)
    trained_model, trained_vectorizer = train_model(dataframe)
    save_model(trained_model, trained_vectorizer)

    print("\nTraining complete!")
BASE_DIR = Path(__file__).resolve().parent
