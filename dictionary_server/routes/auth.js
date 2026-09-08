import { Router } from "express";
import jwt from "jsonwebtoken";
import { v4 as uuidv4 } from "uuid";
import { Redis } from "@upstash/redis";
import { generateTokens } from "../utils/tokenUtils.js";

const router = Router();

// Guest Registration
router.post("/anonymous", async (req, res) => {
  const userId = `guest_${uuidv4()}`;
  const tokens = generateTokens(userId);

  try {
    const redis = Redis.fromEnv();
    // Store refresh token in Redis with a 30-day expiration (2592000 seconds)
    await redis.set(`refresh:${userId}`, tokens.refreshToken, { ex: 2592000 });

    return res.json({
      userId,
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
    });
  } catch (error) {
    console.error("Redis storage error:", error);
    return res.status(500).json({ error: "Failed to initialize guest session" });
  }
});

// Refresh Access Token
router.post("/refresh", async (req, res) => {
  const { refreshToken } = req.body;

  if (!refreshToken) {
    return res.status(401).json({ error: "Refresh token required" });
  }

  const refreshSecret = process.env.REFRESH_TOKEN_SECRET || "refresh_secret";

  jwt.verify(refreshToken, refreshSecret, async (err, decoded) => {
    if (err) {
      return res.status(403).json({ error: "Invalid or expired refresh token" });
    }

    const userId = decoded.userId;

    try {
      const redis = Redis.fromEnv();
      const savedRefreshToken = await redis.get(`refresh:${userId}`);

      if (!savedRefreshToken || savedRefreshToken !== refreshToken) {
        return res.status(403).json({ error: "Session invalid or revoked" });
      }

      const newTokens = generateTokens(userId);
      // Update stored refresh token with a fresh 30-day expiration
      await redis.set(`refresh:${userId}`, newTokens.refreshToken, { ex: 2592000 });

      return res.json({
        accessToken: newTokens.accessToken,
        refreshToken: newTokens.refreshToken,
      });
    } catch (error) {
      console.error("Redis session verification error:", error);
      return res.status(500).json({ error: "Internal server error" });
    }
  });
});

export default router;
