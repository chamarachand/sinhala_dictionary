import { Router } from "express";
import jwt from "jsonwebtoken";
import { v4 as uuidv4 } from "uuid";
import { generateTokens } from "../utils/tokenUtils.js";
import { users } from "../storage/userStore.js";

const router = Router();

// Guest Registration
router.post("/anonymous", (req, res) => {
  const userId = `guest_${uuidv4()}`;
  const tokens = generateTokens(userId);

  users.set(userId, {
    refreshToken: tokens.refreshToken,
    dailyCount: 0,
    lastReset: new Date().toDateString(),
  });

  return res.json({
    userId,
    accessToken: tokens.accessToken,
    refreshToken: tokens.refreshToken,
  });
});

// Refresh Access Token
router.post("/refresh", (req, res) => {
  const { refreshToken } = req.body;

  if (!refreshToken) {
    return res.status(401).json({ error: "Refresh token required" });
  }

  const refreshSecret = process.env.REFRESH_TOKEN_SECRET || "refresh_secret";

  jwt.verify(refreshToken, refreshSecret, (err, decoded) => {
    if (err) {
      return res.status(403).json({ error: "Invalid or expired refresh token" });
    }

    const userId = decoded.userId;
    const user = users.get(userId);

    if (!user || user.refreshToken !== refreshToken) {
      return res.status(403).json({ error: "Session invalid" });
    }

    const newTokens = generateTokens(userId);
    user.refreshToken = newTokens.refreshToken;

    return res.json({
      accessToken: newTokens.accessToken,
      refreshToken: newTokens.refreshToken,
    });
  });
});

export default router;
