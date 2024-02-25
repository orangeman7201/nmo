class Api::V1::ConditionsController < Api::V1::BaseController
  before_action :set_condition, only: [:show, :update, :destroy]

  def index
    @conditions = Condition.all
    # Todo: userログインができたらuserで絞る
    render json: @conditions, each_serializer: ConditionSerializer
  end

  def show
    render json: @condition, serializer: ConditionSerializer
  end

  def create
    @condition = Condition.new(condition_params)
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

  def condition_params
    params.require(:condition).permit(:detail, :occurred_date)
  end

  def set_condition
    @condition = Condition.find(params[:id])
  end
end
