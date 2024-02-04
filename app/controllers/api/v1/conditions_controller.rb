class Api::V1::ConditionsController < ApplicationController
  before_action :set_condition, only: [:show, :update, :delete]

  def index
    @conditions = Condition.all
    # Todo: userログインができたらuserで絞る
    render json: @conditions, each_serializer: ConditionSerializer
  end

  def show
  end

  def create
  end

  def update
    @condition.update(condition_params)
  end

  def delete
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
