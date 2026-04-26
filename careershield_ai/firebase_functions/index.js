/**
 * CareerShield AI - Firebase Cloud Functions
 * Connects Flutter app to Python ML backend
 */

const functions = require("firebase-functions");
const admin = require("firebase-admin");
const axios = require("axios");

admin.initializeApp();
const db = admin.firestore();

const ML_BACKEND_URL = process.env.ML_BACKEND_URL || "http://localhost:8080";

exports.detectScam = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "User must be signed in.",
    );
  }

  const userId = context.auth.uid;
  const { jobText } = data;

  if (!jobText || jobText.trim().length < 20) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Job text is too short.",
    );
  }

  try {
    const response = await axios.post(
      `${ML_BACKEND_URL}/detect-scam`,
      { job_text: jobText },
      { timeout: 30000 },
    );

    const result = response.data;

    const docRef = await db.collection("scam_checks").add({
      userId,
      jobText: jobText.substring(0, 500),
      verdict: result.verdict,
      riskScore: result.risk_score,
      redFlags: result.red_flags,
      explanation: result.explanation,
      recommendation: result.recommendation,
      scamType: result.scam_type,
      isScam: result.is_scam,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
    });

    await db.collection("users").doc(userId).set(
      {
        totalScans: admin.firestore.FieldValue.increment(1),
        lastActive: admin.firestore.FieldValue.serverTimestamp(),
      },
      { merge: true },
    );

    return {
      success: true,
      checkId: docRef.id,
      ...result,
    };
  } catch (error) {
    console.error("detectScam error:", error);
    throw new functions.https.HttpsError(
      "internal",
      "Scam detection failed. Please try again.",
    );
  }
});

exports.analyzeSkillGap = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "User must be signed in.",
    );
  }

  const userId = context.auth.uid;
  const { userSkills, targetRole } = data;

  if (!userSkills || userSkills.length === 0) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Please provide your current skills.",
    );
  }

  if (!targetRole) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Please provide your target role.",
    );
  }

  try {
    const response = await axios.post(
      `${ML_BACKEND_URL}/skill-gap`,
      {
        user_skills: userSkills,
        target_role: targetRole,
      },
      { timeout: 30000 },
    );

    const result = response.data;

    const docRef = await db.collection("skill_checks").add({
      userId,
      userSkills,
      targetRole,
      matchScore: result.match_score,
      missingSkills: result.missing_skills,
      matchedSkills: result.matched_skills,
      readiness: result.readiness,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
    });

    return {
      success: true,
      checkId: docRef.id,
      ...result,
    };
  } catch (error) {
    console.error("analyzeSkillGap error:", error);
    throw new functions.https.HttpsError(
      "internal",
      "Skill gap analysis failed. Please try again.",
    );
  }
});

exports.getUserHistory = functions.https.onCall(async (_, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "User must be signed in.",
    );
  }

  const userId = context.auth.uid;

  try {
    const scamChecks = await db
      .collection("scam_checks")
      .where("userId", "==", userId)
      .orderBy("timestamp", "desc")
      .limit(10)
      .get();

    const skillChecks = await db
      .collection("skill_checks")
      .where("userId", "==", userId)
      .orderBy("timestamp", "desc")
      .limit(10)
      .get();

    return {
      scamHistory: scamChecks.docs.map((doc) => ({
        id: doc.id,
        ...doc.data(),
        timestamp: doc.data().timestamp?.toDate(),
      })),
      skillHistory: skillChecks.docs.map((doc) => ({
        id: doc.id,
        ...doc.data(),
        timestamp: doc.data().timestamp?.toDate(),
      })),
    };
  } catch (error) {
    console.error("getUserHistory error:", error);
    throw new functions.https.HttpsError("internal", "Failed to fetch history.");
  }
});

exports.getDashboardStats = functions.https.onCall(async (_, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "User must be signed in.",
    );
  }

  try {
    const skillsResponse = await axios.get(`${ML_BACKEND_URL}/trending-skills`);
    const rolesResponse = await axios.get(`${ML_BACKEND_URL}/all-roles`);

    const totalScams = await db
      .collection("scam_checks")
      .where("isScam", "==", true)
      .get();

    return {
      trendingSkills: skillsResponse.data.trending_skills,
      availableRoles: rolesResponse.data.roles,
      platformStats: {
        totalScamsDetected: totalScams.size,
        studentsProtected: Math.floor(totalScams.size * 0.8),
      },
    };
  } catch (error) {
    console.error("getDashboardStats error:", error);
    throw new functions.https.HttpsError(
      "internal",
      "Failed to fetch dashboard stats.",
    );
  }
});
