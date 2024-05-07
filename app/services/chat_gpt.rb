class ChatGpt
  require 'openai'

  def initialize
    @openai = OpenAI::Client.new()
  end

  def chat(prompt)
    response = @openai.chat(
      parameters: {
        model: "gpt-3.5-turbo", # Required. # 使用するGPT-3のエンジンを指定
        messages: [{ role: "system", content: "response with json(japanese). I'm going to give you the patient's symptoms and the date it happened, and you're going to give me back a summary in one thing and details that I can read in 30 seconds or less." },
                   { role: "user", content: prompt }],
        response_format: { type: "json_object" },
        temperature: 0.7, # 応答のランダム性を指定
        max_tokens: 200,  # 応答の長さを指定
      },
      )
    response.dig('choices', 0, 'message', 'content')
  end
end