import { GoogleGenAI } from "@google/genai";

export async function fetchSinhalaInsight(word) {
  const ai = new GoogleGenAI({ apiKey: process.env.GEMINI_API_KEY });
  const promptText = `Analyze the English word: "${word}"

      Provide the output strictly in Sinhala (සිංහල) with the following exact format:

      ### 📖 ප්‍රධාන තේරුම (Direct Translation)
      Provide 1-3 primary Sinhala direct equivalent words separated by commas.

      ### 💡 පැහැදිලි කිරීම (Simple Explanation)
      Explain the word in 2-3 simple, natural Sinhala sentences.

      Rules:
      - Keep it concise and natural.
      - Do not include introductory text.
  `;

  const response = await ai.models.generateContent({
    model: "gemini-2.5-flash",
    contents: promptText,
    config: {
      systemInstruction:
        "You are an expert Sinhala English dictionary assistant. Follow formatting rules strictly and respond only in clear, native Sinhala.",
      temperature: 0.2,
      maxOutputTokens: 300,
      thinkingConfig: {
        thinkingBudget: 0,
      },
    },
  });

  return (response.text || "").trim();
}
