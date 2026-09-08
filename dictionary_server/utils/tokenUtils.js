import jwt from "jsonwebtoken";

export function generateTokens(userId) {
  const accessToken = jwt.sign({ userId }, process.env.ACCESS_TOKEN_SECRET || "access_secret", {
    expiresIn: "15m",
  });

  const refreshToken = jwt.sign({ userId }, process.env.REFRESH_TOKEN_SECRET || "refresh_secret", {
    expiresIn: "30d",
  });

  return { accessToken, refreshToken };
}
