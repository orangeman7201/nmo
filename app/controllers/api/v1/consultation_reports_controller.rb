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
  end

  def destroy
    @consultation_report.destroy
  end

  # AIによる気になることのまとめを生成するエンドポイント
  def generate_ai_summary
    # 実際のAI要約処理は次のタスクで実装
    # 現時点では、仮のレスポンスを返す
    @consultation_report.update(condition_summary: "AI要約は次のタスクで実装されます。")
    
    render json: { 
      success: true, 
      message: "AI要約が生成されました", 
      condition_summary: @consultation_report.condition_summary 
    }
  end

  private

  def consultation_report_params
    params.require(:consultation_report).permit(:hospital_appointment_id, :consultation_memo, :condition_summary)
  end

  def set_consultation_report
    @consultation_report = current_user.consultation_reports.find(params[:id])
  end
end
