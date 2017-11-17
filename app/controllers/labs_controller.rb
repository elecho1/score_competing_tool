class LabsController < ApplicationController
  #callback
  before_action :authenticate_user!
  before_action :registered_scores?

  def show
    # self info
    @mylab = current_user.lab
    if @mylab
      mylab_applicants = @mylab.users.includes(:user_score)
      @mylab_reordered_applicants = mylab_applicants.sort{|a, b| b.user_score.total_score <=> a.user_score.total_score}
      @my_standing = 1
      @mylab_reordered_applicants.each do |applicant|
        if applicant.user_score.total_score > current_user.user_score.total_score
          @my_standing += 1
        end
      end
    end

    # every lab info
    @users = User.all
    @labs = Lab.all.order(:id)
    @labs_info = Array.new(@labs.length)
    for i in 0..(@labs.length-1) do
      @labs_info[i] = Hash.new
      @labs_info[i]['lab'] = @labs[i]
      @labs_info[i]['num'] = 0
    end
    # @labs_applicants = Array.new(@labs.length, 0)
    @users.each do |user|
      if user.lab_id
        this_lab_info = @labs_info.find{|lab_info| lab_info['lab'].id == user.lab_id}
        this_lab_info['num'] += 1
      end
    end
    @unregistered_users_num = @users.length - @labs_info.inject(0){|sum, lab_info| sum+lab_info['num']}
  end

  private
  def registered_scores?
    if current_user.user_score.blank?
      redirect_to please_register_your_scores_path
      return
    end
  end
end
