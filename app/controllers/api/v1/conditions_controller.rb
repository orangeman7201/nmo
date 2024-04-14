class Api::V1::ConditionsController < Api::V1::BaseController
  before_action :set_condition, only: [:show, :update, :destroy]

  def index
    @conditions = current_user.conditions.in_target_month(get_condition_params[:target_month])
    render json: @conditions, each_serializer: ConditionSerializer
  end

  def show
    render json: @condition, serializer: ConditionSerializer
  end

  def create
    @condition = current_user.conditions.build(condition_params)
    @condition.save
    render json: @condition, serializer: ConditionSerializer
  end

  def update
    @condition.update(condition_params)
  end

  def destroy
    @condition.destroy
  end

  private

  def get_condition_params
    params.permit(:target_month)
  end

  def condition_params
    params.require(:condition).permit(:detail, :occurred_date, :strength, :memo)
  end

  def set_condition
    @condition = current_user.conditions.find(params[:id])
  end
end
