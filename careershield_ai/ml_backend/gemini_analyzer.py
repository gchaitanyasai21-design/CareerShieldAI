"""
CareerShield AI - Gemini API Integration
Uses Google Gemini to generate human-readable
explanations for scam predictions.
"""

import json
import os

import google.generativeai as genai
from dotenv import load_dotenv


load_dotenv()

GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")
if GEMINI_API_KEY:
    genai.configure(api_key=GEMINI_API_KEY)
    gemini_model = genai.GenerativeModel("gemini-1.5-flash")
else:
    gemini_model = None


def get_verdict(risk_score: float) -> str:
    """Convert risk score to verdict string."""
    if risk_score <= 30:
        return "SAFE"
    if risk_score <= 65:
        return "SUSPICIOUS"
    return "HIGH RISK"


def _strip_json_fence(raw_text: str) -> str:
    if raw_text.startswith("```"):
        raw_text = raw_text.split("```")[1]
        if raw_text.startswith("json"):
            raw_text = raw_text[4:]
    return raw_text.strip()


def analyze_job_with_gemini(job_text: str, ml_risk_score: float) -> dict:
    """Use Gemini to analyze job posting and explain risk."""
    if not gemini_model:
        return {
            "verdict": get_verdict(ml_risk_score),
            "risk_score": ml_risk_score,
            "red_flags": ["Gemini API key is not configured"],
            "positive_signals": [],
            "explanation": (
                f"This posting has a {ml_risk_score}% risk score based on the ML model."
            ),
            "recommendation": "Configure Gemini to enable detailed explanations.",
            "scam_type": "Unknown",
        }

    prompt = f"""
    You are CareerShield AI, an expert system that protects students from fake job and internship scams.

    Analyze the following job posting carefully:

    ===JOB POSTING START===
    {job_text[:2000]}
    ===JOB POSTING END===

    Our ML model gave this posting a scam risk score of {ml_risk_score}% (higher = more suspicious).

    Based on your analysis, return a JSON response ONLY.
    No extra text. Just valid JSON.

    JSON Format:
    {{
      "verdict": "SAFE" or "SUSPICIOUS" or "HIGH RISK",
      "risk_score": <number between 0 and 100>,
      "red_flags": ["specific red flag 1", "specific red flag 2", "specific red flag 3"],
      "positive_signals": ["positive thing 1 (if any)"],
      "explanation": "2-3 sentence simple explanation for a student",
      "recommendation": "One clear action the student should take",
      "scam_type": "Payment Scam" or "Data Harvest Scam" or "Fake Company" or "Too Good To Be True" or "Legitimate"
    }}

    Rules for verdict:
    - SAFE: risk_score 0-30
    - SUSPICIOUS: risk_score 31-65
    - HIGH RISK: risk_score 66-100
    """

    try:
        response = gemini_model.generate_content(prompt)
        result = json.loads(_strip_json_fence(response.text.strip()))
        return result
    except json.JSONDecodeError:
        return {
            "verdict": get_verdict(ml_risk_score),
            "risk_score": ml_risk_score,
            "red_flags": ["Unable to parse detailed analysis"],
            "positive_signals": [],
            "explanation": (
                f"This posting has a {ml_risk_score}% risk score based on our ML model analysis."
            ),
            "recommendation": "Exercise caution before applying to this position.",
            "scam_type": "Unknown",
        }
    except Exception as e:
        return {
            "verdict": get_verdict(ml_risk_score),
            "risk_score": ml_risk_score,
            "red_flags": [f"Analysis error: {str(e)}"],
            "positive_signals": [],
            "explanation": "Analysis failed. Use ML score as reference.",
            "recommendation": "Verify this job manually.",
            "scam_type": "Unknown",
        }


def generate_learning_path(missing_skills: list, target_role: str, match_score: float) -> dict:
    """Generate personalized learning roadmap using Gemini."""
    if not gemini_model:
        return {
            "roadmap": [
                {
                    "month": i + 1,
                    "skill": skill,
                    "resource": "Search on YouTube",
                    "resource_url": "https://youtube.com",
                    "hours_per_week": 5,
                    "milestone": f"Basic understanding of {skill}",
                }
                for i, skill in enumerate(missing_skills[:3])
            ],
            "total_hours": 60,
            "motivation": "Every expert was once a beginner!",
            "job_ready_in": "3-6 months",
        }

    prompt = f"""
    You are CareerShield AI's career counselor.

    A student wants to become a {target_role}.
    Their current skill match is {match_score}%.
    They are missing these skills: {', '.join(missing_skills)}.

    Create a simple, realistic 3-month learning roadmap.
    Return JSON ONLY. No extra text.

    JSON Format:
    {{
      "roadmap": [
        {{
          "month": 1,
          "skill": "Skill name",
          "resource": "Free resource name",
          "resource_url": "actual URL",
          "hours_per_week": <number>,
          "milestone": "What they can do after this month"
        }}
      ],
      "total_hours": <total study hours>,
      "motivation": "One encouraging sentence for the student",
      "job_ready_in": "Estimated time to job readiness"
    }}
    """

    try:
        response = gemini_model.generate_content(prompt)
        return json.loads(_strip_json_fence(response.text.strip()))
    except Exception:
        return {
            "roadmap": [
                {
                    "month": i + 1,
                    "skill": skill,
                    "resource": "Search on YouTube",
                    "resource_url": "https://youtube.com",
                    "hours_per_week": 5,
                    "milestone": f"Basic understanding of {skill}",
                }
                for i, skill in enumerate(missing_skills[:3])
            ],
            "total_hours": 60,
            "motivation": "Every expert was once a beginner!",
            "job_ready_in": "3-6 months",
        }
