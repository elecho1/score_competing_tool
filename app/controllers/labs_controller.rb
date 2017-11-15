class LabsController < ApplicationController
  #callback
  before_action :authenticate_user!
  before_action :registered_scores?

  def show
  end

  private
  def registered_scores?
    if current_user.user_score.blank?
      redirect_to please_register_your_scores_path
      return
    end
  end
end
