import Groq from "groq-sdk";

export async function fetchEnglishInsight(word, level = "B1") {
  const groq = new Groq({ apiKey: process.env.GROQ_API_KEY });
  const prompt = `
      Analyze the word: "${word}"

      Structure your response using these exact section titles:

      ### 💡 Meaning & Usage
      Explain the meaning clearly using simple, common English words suitable for non-native speakers (CEFR ${level} level).

      ### 📝 Examples
      Provide 3 natural sentences showing how the word, ${word} is used in real life as a bulleted list in plain text.

      ### ⚡ Memory Tip
      Give a simple trick to help remember the meaning or usage in plain text.

      CRITICAL FORMATTING RULES:
      - Keep each section concise
      - Do NOT use bolding (**word** or __word__)
      - Do NOT use italics (*word* or _word_)
      - Do not add extra sections
      - Do not use synonyms lists
  `;

  const chatCompletion = await groq.chat.completions.create({
    model: "openai/gpt-oss-20b",
    temperature: 0.0,
    max_tokens: 400,
    messages: [
      {
        role: "system",
        content:
          "You are an expert English dictionary assistant. STRICT RULE: Respond only in plain text under markdown headers. NEVER use bold (**text**) or italic (*text*) formatting anywhere in your response.",
      },
      { role: "user", content: prompt },
    ],
  });

  const content = chatCompletion.choices[0]?.message?.content || "";

  return content
    .replace(/\*\*(.*?)\*\*/g, "$1")
    .replace(/(?<!^\s*)[\*\_](?!\s)(.*?)(?<!\s)[\*\_]/g, "$1")
    .trim();
}
