import { users } from "../storage/userStore.js";

export function checkDailyQuota(req, res, next) {
  const userId = req.userId;
  const user = users.get(userId);

  if (!user) {
    return res.status(401).json({ error: "User session not found" });
  }

  const today = new Date().toDateString();

  // Reset quota if it's a new day
  if (user.lastReset !== today) {
    user.dailyCount = 0;
    user.lastReset = today;
  }

  const DAILY_LIMIT = 20; //
  if (user.dailyCount >= DAILY_LIMIT) {
    return res.status(429).json({
      error: `Daily limit reached (${DAILY_LIMIT}/${DAILY_LIMIT}). Try again tomorrow!`,
    });
  }

  user.dailyCount += 1;
  next();
}
