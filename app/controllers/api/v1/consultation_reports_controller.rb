class Api::V1::ConsultationReportsController < Api::V1::BaseController
  before_action :set_consultation_report, only: [:show, :update, :destroy, :generate_ai_summary]

  def index
    @consultation_reports = current_user.consultation_reports
    render json: @consultation_reports, each_serializer: ConsultationReportSerializer
  end

  def show
    render json: @consultation_report, serializer: ConsultationReportSerializer
  end

  def create
    @consultation_report = current_user.consultation_reports.build(consultation_report_params)
    @consultation_report.set_date
    @consultation_report.save
    render json: @consultation_report, serializer: ConsultationReportSerializer
  end

  def update
    @consultation_report.update(consultation_report_params)
    render json: @consultation_report, serializer: ConsultationReportSerializer
  end

  def destroy
    @consultation_report.destroy
  end

  def generate_ai_summary
    # 関連する体調情報を取得
    conditions = current_user.conditions.where(occurred_date: @consultation_report.start_date..@consultation_report.end_date)
    
    if conditions.empty?
      render json: { success: false, message: '要約するための体調情報がありません。' }, status: :unprocessable_entity
      return
    end
    
    # 体調情報をプロンプト用にフォーマット
    prompt = format_conditions_for_prompt(conditions)
    
    # ChatGptを使用して要約を生成
    chat_gpt = ChatGpt.new
    begin
      summary = chat_gpt.chat(prompt)
      
      # 要約を保存
      @consultation_report.update(condition_summary: summary)
      
      render json: { 
        success: true, 
        message: 'AI要約が生成されました。', 
        condition_summary: summary 
      }
    rescue => e
      Rails.logger.error("AI要約の生成に失敗しました: #{e.message}")
      render json: { success: false, message: 'AI要約の生成に失敗しました。' }, status: :unprocessable_entity
    end
  end

  private

  def consultation_report_params
    params.require(:consultation_report).permit(:hospital_appointment_id, :consultation_memo, :condition_summary)
  end

  def set_consultation_report
    @consultation_report = current_user.consultation_reports.find(params[:id])
  end
  
  def format_conditions_for_prompt(conditions)
    formatted_conditions = conditions.map do |condition|
      "日付: #{condition.occurred_date}, 症状: #{condition.detail}, 強さ: #{condition.strength}, メモ: #{condition.memo}"
    end.join("\n")
    
    "以下の症状情報を30秒以内で読める簡潔な要約にしてください。要約は日本語のJSONフォーマットで返してください。JSONには「summary」と「details」のフィールドを含めてください。\n\n#{formatted_conditions}"
  end
end
