// middleware/quota.js
import { Redis } from "@upstash/redis";

export async function checkDailyQuota(req, res, next) {
  const userId = req.userId;

  if (!userId) {
    return res.status(401).json({ error: "User session not found" });
  }

  const redis = Redis.fromEnv();

  const today = new Date().toISOString().split("T")[0]; // YYYY-MM-DD
  const quotaKey = `quota:${userId}:${today}`;
  const DAILY_LIMIT = 25;

  try {
    const currentCount = await redis.incr(quotaKey);

    // Set 24h key expiration on the first request of the day
    if (currentCount === 1) {
      await redis.expire(quotaKey, 86400);
    }

    if (currentCount > DAILY_LIMIT) {
      return res.status(429).json({
        error: `Daily limit reached (${DAILY_LIMIT}/${DAILY_LIMIT}). Try again tomorrow!`,
      });
    }

    next();
  } catch (error) {
    console.error("Redis quota error:", error);
    return res.status(500).json({ error: "Internal server error checking quota" });
  }
}
