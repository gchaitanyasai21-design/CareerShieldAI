"""
CareerShield AI - Flask API Server
Connects ML model + Gemini to Firebase Cloud Functions.
"""

import traceback

from flask import Flask, jsonify, request
from flask_cors import CORS

from career_intel import calculate_skill_gap, get_all_roles, get_trending_skills
from gemini_analyzer import analyze_job_with_gemini, generate_learning_path
from predict import MODEL_READY, predict_scam


app = Flask(__name__)
CORS(app)


@app.route("/health", methods=["GET"])
def health():
    return jsonify(
        {
            "status": "CareerShield AI is running",
            "version": "1.0.0",
            "model_ready": MODEL_READY,
        }
    )


@app.route("/detect-scam", methods=["POST"])
def detect_scam():
    try:
        data = request.get_json()

        if not data or "job_text" not in data:
            return jsonify({"error": "Missing 'job_text' in request body"}), 400

        job_text = data["job_text"].strip()
        if len(job_text) < 20:
            return jsonify({"error": "Job text is too short to analyze"}), 400

        ml_result = predict_scam(job_text)
        gemini_result = analyze_job_with_gemini(job_text, ml_result["risk_score"])

        final_result = {
            "verdict": gemini_result.get("verdict", "UNKNOWN"),
            "risk_score": gemini_result.get("risk_score", ml_result["risk_score"]),
            "red_flags": gemini_result.get("red_flags", []),
            "positive_signals": gemini_result.get("positive_signals", []),
            "explanation": gemini_result.get("explanation", ""),
            "recommendation": gemini_result.get("recommendation", ""),
            "scam_type": gemini_result.get("scam_type", "Unknown"),
            "ml_confidence": ml_result["confidence"],
            "is_scam": ml_result["is_scam"],
            "model_source": ml_result.get("model_source", "trained"),
        }

        return jsonify(final_result), 200
    except Exception as e:
        print(f"Error in detect_scam: {str(e)}")
        print(traceback.format_exc())
        return jsonify({"error": "Analysis failed", "details": str(e)}), 500


@app.route("/skill-gap", methods=["POST"])
def skill_gap():
    try:
        data = request.get_json()

        if not data:
            return jsonify({"error": "No data provided"}), 400

        user_skills = data.get("user_skills", [])
        target_role = data.get("target_role", "")

        if not user_skills:
            return jsonify({"error": "Please provide your current skills"}), 400

        if not target_role:
            return jsonify({"error": "Please provide your target role"}), 400

        gap_result = calculate_skill_gap(user_skills, target_role)
        if "error" in gap_result:
            return jsonify(gap_result), 400

        learning_path = None
        if gap_result["missing_skills"]:
            learning_path = generate_learning_path(
                missing_skills=gap_result["missing_skills"],
                target_role=target_role,
                match_score=gap_result["match_score"],
            )

        return jsonify({**gap_result, "learning_path": learning_path}), 200
    except Exception as e:
        print(f"Error in skill_gap: {str(e)}")
        print(traceback.format_exc())
        return jsonify({"error": "Skill gap analysis failed", "details": str(e)}), 500


@app.route("/trending-skills", methods=["GET"])
def trending_skills():
    try:
        return jsonify({"trending_skills": get_trending_skills()}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route("/all-roles", methods=["GET"])
def all_roles():
    try:
        return jsonify({"roles": get_all_roles()}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080, debug=True)
