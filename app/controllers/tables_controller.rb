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

    @user_scores_2A = @user_scores.sort{|a, b| b.sem4_total_score <=> a.sem4_total_score}
    @subjects_2A = @subjects.select{|subject| subject.semester == 4}
    @subject_ids_2A = @subjects_2A.map do |subject|
      subject.id
    end

    @user_scores_3S = @user_scores.sort{|a, b| b.sem5_total_score <=> a.sem5_total_score}
    @subjects_3S = @subjects.select{|subject| subject.semester == 5}
    @subject_ids_3S = @subjects_3S.map do |subject|
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
