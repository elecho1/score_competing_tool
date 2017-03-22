class TablesController < ApplicationController
  #callback
  before_action :authenticate_user!
  before_action :registered_scores?

  def show
    @user_scores = UserScore.all.includes([:user, :scores, :subjects]).order(total_score: :DESC)
    @subjects = Subject.all.order(:id)

    #@subject_ids = Array.new
    #@subject_ids = @subjects.pluck(:id)
    
    @subject_ids = @subjects.map do |subject|
      subject.id
    end
  end 

  private
  def registered_scores?
    if current_user.user_score.blank?
      redirect_to please_register_your_scores_path
      return
    end
  end
end
