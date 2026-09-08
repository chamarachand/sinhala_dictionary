import { Router } from "express";
import { authenticateToken } from "../middleware/auth.js";
import { checkDailyQuota } from "../middleware/quota.js";
import { fetchEnglishInsight } from "../services/groqService.js";
import { fetchSinhalaInsight } from "../services/geminiService.js";

const router = Router();

// English Insights Route
router.post("/english", authenticateToken, checkDailyQuota, async (req, res) => {
  try {
    const { word, level = "B1" } = req.body;

    if (!word || typeof word !== "string") {
      return res.status(400).json({ error: 'A valid "word" string is required.' });
    }

    const result = await fetchEnglishInsight(word, level);
    return res.json({ result });
  } catch (error) {
    console.error("Groq API Error:", error);
    if (error?.status === 429) {
      return res.status(429).json({ error: "Groq provider rate limit hit." });
    }
    return res.status(500).json({ error: "Failed to generate AI insights." });
  }
});

// Sinhala Insights Route
router.post("/sinhala", authenticateToken, checkDailyQuota, async (req, res) => {
  try {
    const { word } = req.body;

    if (!word || typeof word !== "string") {
      return res.status(400).json({ error: 'A valid "word" string is required.' });
    }

    const result = await fetchSinhalaInsight(word);
    return res.json({ result });
  } catch (error) {
    console.error("Gemini SDK Error:", error);
    return res.status(500).json({ error: "Failed to generate Sinhala explanation." });
  }
});

export default router;
