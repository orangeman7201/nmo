class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken

  # deviceの日本語化のための記述
  before_action do
    I18n.locale = :ja
  end

  protect_from_forgery with: :exception
end
