class ChatGpt
  require 'openai'

  def initialize
    @client = OpenAI::Client.new()
  end

  def chat(prompt)
    response = @client.chat(
      parameters: {
        model: "gpt-4o-mini",
        messages: [
          {
            role: "system",
            content: <<~PROMPT
              あなたは医療アシスタントとして、contentのJSONデータを元に私の症状サマリーを医師に提示することを想定した文章形式で要約してください。。
              体調や心身に関する症状のみを抽出してください。要約は完全に文章として構成してください。箇条書きは一切使用しないでください。
              要約文章には、各症状の詳細、強度を表現する日本語（例：10段階で10なら「非常に強い」、9なら「かなり強い」、7なら「中程度の」、3なら「軽めの」など）、および発生時期を含めてください。発生時期については、JSONのoccurred_dateの情報を基に、現在のシステム日付を基準として、「約〇週間前」や「〇月〇旬頃」のような簡易的な期間表現に変換して記述してください（今回のデータの場合は「〇月〇旬頃」が適切と考えられます）。
              要約文章は、症状は強度が高いものから順に構成してください。
              医師に見せる際にそのまま使用できるよう、余分な説明や補足は含めないでください。
            PROMPT
          },
          { role: "user", content: prompt }
        ],
        temperature: 0.3,  # より一貫性のある応答のために低く設定
        max_tokens: 500,   # より詳細な応答のために増加
      }
    )

    response.dig("choices", 0, "message", "content")
  rescue OpenAI::Error => e
    Rails.logger.error "ChatGPT API Error: #{e.message}"
    { error: "AI処理中にエラーが発生しました" }
  rescue JSON::ParserError => e
    Rails.logger.error "JSON Parse Error: #{e.message}"
    { error: "レスポンスの解析に失敗しました" }
  end
end
