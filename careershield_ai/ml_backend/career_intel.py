"""
CareerShield AI - Career Intelligence Module
Handles skill gap analysis and career path logic.
"""

SKILLS_DATABASE = {
    "Data Analyst": {
        "required_skills": [
            "Python",
            "SQL",
            "Excel",
            "Tableau",
            "Statistics",
            "Power BI",
            "Data Visualization",
        ],
        "nice_to_have": ["R", "Machine Learning basics"],
        "avg_salary_inr": "6-12 LPA",
        "avg_salary_usd": "$55,000-$85,000",
        "demand_level": "High",
        "demand_score": 85,
        "growth_rate": "23% by 2031",
        "top_companies": ["Google", "Amazon", "Deloitte"],
        "description": "Analyzes data to help businesses make decisions.",
    },
    "Machine Learning Engineer": {
        "required_skills": [
            "Python",
            "TensorFlow",
            "PyTorch",
            "Mathematics",
            "Statistics",
            "MLOps",
            "SQL",
        ],
        "nice_to_have": ["Kubernetes", "Docker", "Spark"],
        "avg_salary_inr": "10-25 LPA",
        "avg_salary_usd": "$100,000-$150,000",
        "demand_level": "Very High",
        "demand_score": 95,
        "growth_rate": "40% by 2031",
        "top_companies": ["Google", "OpenAI", "Meta"],
        "description": "Builds and deploys machine learning models.",
    },
    "Flutter App Developer": {
        "required_skills": [
            "Flutter",
            "Dart",
            "Firebase",
            "REST APIs",
            "Git",
            "UI/UX basics",
            "State Management",
        ],
        "nice_to_have": ["Native Android", "Native iOS"],
        "avg_salary_inr": "5-15 LPA",
        "avg_salary_usd": "$60,000-$110,000",
        "demand_level": "High",
        "demand_score": 80,
        "growth_rate": "22% by 2031",
        "top_companies": ["Google", "Startups", "Freelance"],
        "description": "Builds cross-platform mobile applications.",
    },
    "Web Developer": {
        "required_skills": [
            "HTML",
            "CSS",
            "JavaScript",
            "React",
            "Node.js",
            "Git",
            "REST APIs",
        ],
        "nice_to_have": ["TypeScript", "Next.js", "Docker"],
        "avg_salary_inr": "4-12 LPA",
        "avg_salary_usd": "$50,000-$100,000",
        "demand_level": "High",
        "demand_score": 82,
        "growth_rate": "16% by 2031",
        "top_companies": ["Any tech company"],
        "description": "Builds websites and web applications.",
    },
    "Data Scientist": {
        "required_skills": [
            "Python",
            "Machine Learning",
            "Statistics",
            "Deep Learning",
            "SQL",
            "Data Visualization",
            "Research skills",
        ],
        "nice_to_have": ["NLP", "Computer Vision", "Spark"],
        "avg_salary_inr": "8-20 LPA",
        "avg_salary_usd": "$90,000-$140,000",
        "demand_level": "Very High",
        "demand_score": 92,
        "growth_rate": "36% by 2031",
        "top_companies": ["Google", "Microsoft", "Netflix"],
        "description": "Extracts insights from complex data.",
    },
    "Cloud Engineer": {
        "required_skills": [
            "Google Cloud Platform",
            "AWS",
            "Docker",
            "Kubernetes",
            "Linux",
            "Networking",
            "Python",
        ],
        "nice_to_have": ["Terraform", "CI/CD", "Security"],
        "avg_salary_inr": "8-20 LPA",
        "avg_salary_usd": "$90,000-$130,000",
        "demand_level": "Very High",
        "demand_score": 90,
        "growth_rate": "30% by 2031",
        "top_companies": ["Google", "AWS", "Microsoft"],
        "description": "Manages cloud infrastructure and services.",
    },
    "Cybersecurity Analyst": {
        "required_skills": [
            "Networking",
            "Linux",
            "Ethical Hacking",
            "Python",
            "Cryptography",
            "SIEM tools",
            "Risk Assessment",
        ],
        "nice_to_have": ["CEH Certification", "CISSP"],
        "avg_salary_inr": "6-18 LPA",
        "avg_salary_usd": "$70,000-$120,000",
        "demand_level": "Very High",
        "demand_score": 93,
        "growth_rate": "35% by 2031",
        "top_companies": ["Banks", "Government", "Tech"],
        "description": "Protects systems from cyber threats.",
    },
    "UI/UX Designer": {
        "required_skills": [
            "Figma",
            "Adobe XD",
            "User Research",
            "Prototyping",
            "Design Systems",
            "Wireframing",
            "Basic HTML/CSS",
        ],
        "nice_to_have": ["Motion Design", "Illustration"],
        "avg_salary_inr": "4-12 LPA",
        "avg_salary_usd": "$55,000-$95,000",
        "demand_level": "High",
        "demand_score": 78,
        "growth_rate": "13% by 2031",
        "top_companies": ["Any product company"],
        "description": "Designs beautiful and usable digital products.",
    },
}


def calculate_skill_gap(user_skills: list, target_role: str) -> dict:
    """Calculate skill gap between user skills and target role requirements."""
    if target_role not in SKILLS_DATABASE:
        return {
            "error": f"Role '{target_role}' not found",
            "available_roles": list(SKILLS_DATABASE.keys()),
        }

    role_data = SKILLS_DATABASE[target_role]
    required = role_data["required_skills"]

    user_lower = [skill.lower().strip() for skill in user_skills]

    matched = [skill for skill in required if skill.lower().strip() in user_lower]
    missing = [skill for skill in required if skill.lower().strip() not in user_lower]

    match_score = round(len(matched) / len(required) * 100)

    if match_score >= 80:
        readiness = "Job Ready"
        readiness_message = "You are almost ready. Polish your portfolio and start applying."
    elif match_score >= 50:
        readiness = "Almost There"
        readiness_message = "Good progress. Learn the missing skills and you will be ready soon."
    else:
        readiness = "Keep Learning"
        readiness_message = "You have a strong foundation. Focus on the missing skills with the roadmap below."

    return {
        "target_role": target_role,
        "match_score": match_score,
        "readiness": readiness,
        "readiness_message": readiness_message,
        "matched_skills": matched,
        "missing_skills": missing,
        "nice_to_have": role_data["nice_to_have"],
        "avg_salary_inr": role_data["avg_salary_inr"],
        "avg_salary_usd": role_data["avg_salary_usd"],
        "demand_level": role_data["demand_level"],
        "demand_score": role_data["demand_score"],
        "growth_rate": role_data["growth_rate"],
        "top_companies": role_data["top_companies"],
        "description": role_data["description"],
        "total_required": len(required),
        "skills_acquired": len(matched),
        "skills_remaining": len(missing),
    }


def get_all_roles() -> list:
    """Return list of all available roles."""
    return [
        {
            "role": role,
            "demand_score": data["demand_score"],
            "salary_inr": data["avg_salary_inr"],
            "demand_level": data["demand_level"],
        }
        for role, data in SKILLS_DATABASE.items()
    ]


def get_trending_skills() -> list:
    """Return top trending skills based on demand across all roles."""
    skill_count = {}

    for role_data in SKILLS_DATABASE.values():
        weight = role_data["demand_score"]
        for skill in role_data["required_skills"]:
            skill_count[skill] = skill_count.get(skill, 0) + weight

    sorted_skills = sorted(skill_count.items(), key=lambda item: item[1], reverse=True)

    return [
        {
            "skill": skill,
            "demand_score": min(score // 10, 100),
            "rank": idx + 1,
        }
        for idx, (skill, score) in enumerate(sorted_skills[:10])
    ]


if __name__ == "__main__":
    result = calculate_skill_gap(
        user_skills=["Python", "Excel", "SQL"],
        target_role="Data Analyst",
    )

    print(f"Role: {result['target_role']}")
    print(f"Match: {result['match_score']}%")
    print(f"Missing: {result['missing_skills']}")
    print(f"Salary: {result['avg_salary_inr']}")
