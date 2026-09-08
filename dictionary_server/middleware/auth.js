import jwt from "jsonwebtoken";

export function authenticateToken(req, res, next) {
  const authHeader = req.headers["authorization"];
  const token = authHeader && authHeader.split(" ")[1];

  if (!token) {
    return res.status(401).json({ error: "Access token required" });
  }

  const secret = process.env.ACCESS_TOKEN_SECRET || "access_secret";

  jwt.verify(token, secret, (err, decoded) => {
    if (err) {
      return res.status(401).json({ error: "Token expired or invalid" });
    }
    req.userId = decoded.userId;
    next();
  });
}
