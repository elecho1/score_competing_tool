class LabsController < ApplicationController
  #callback
  before_action :authenticate_user!
  before_action :registered_scores?

  def show
    # self info
    @mylab = current_user.lab
    if @mylab
      mylab_applicants_rel = @mylab.users.includes(:user_score)
      mylab_applicants = mylab_applicants_rel.select{|user| user.user_score}
      @mylab_reordered_applicants = mylab_applicants.sort{|a, b| b.user_score.total_score <=> a.user_score.total_score}
      @my_standing = 1
      @mylab_reordered_applicants.each do |applicant|
        if applicant.user_score.total_score > current_user.user_score.total_score
          @my_standing += 1
        end
      end
    end

    # every lab info
    #@users = User.all
    @user_scores = UserScore.all.includes(:user)
    @labs = Lab.all.order(:id)
    @labs_info = Array.new(@labs.length)
    for i in 0..(@labs.length-1) do
      @labs_info[i] = Hash.new
      @labs_info[i]['lab'] = @labs[i]
      @labs_info[i]['num'] = 0
    end
    #@users.each do |user|
    @user_scores.each do |user_score|
      #if user.lab_id
      if user_score.user.lab_id
        this_lab_info = @labs_info.find{|lab_info| lab_info['lab'].id == user_score.user.lab_id}
        this_lab_info['num'] += 1
      end
    end
    @registered_users_num = @labs_info.inject(0){|sum, lab_info| sum+lab_info['num']}
    @unregistered_users_num = @user_scores.length - @registered_users_num
  end

  private
  def registered_scores?
    if current_user.user_score.blank?
      redirect_to please_register_your_scores_path
      return
    end
  end
end
