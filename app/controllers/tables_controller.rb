class TablesController < ApplicationController
  #callback
  before_action :authenticate_user!
  before_action :registered_scores?

  def show
    @user_scores = UserScore.all.includes([:user, :scores, :subjects, :semester_scores]).order(total_score: :DESC)
    @subjects = Subject.all.order(:id)

    @semester_scores = SemesterScore.all

    # 総合得点グラフの描画用
    @my_total_score = UserScore.find{|data| data.user_id == current_user.id}.total_score
    @user_scores_max = @user_scores[0].total_score
    @user_scores_min = @user_scores[@user_scores.length - 1].total_score
    @label_interval = (@user_scores_max -   @user_scores_min) / 10
    @user_scores_number = @user_scores.map do |data|
      data.total_score
    end
    @label_count = @user_scores_number.group_by{|data| ((data -  @user_scores_min)/@label_interval).floor}
    @label_count_num = []
    for num in 0..10 do
      unless @label_count[num].nil?
        @label_count_num.push(@label_count[num].length)
      else
        @label_count_num.push(0)
      end
    end





    #@subject_ids = Array.new
    #@subject_ids = @subjects.pluck(:id)

    @subject_ids = @subjects.map do |subject|
      subject.id
    end

    @user_scores_2A = @user_scores.sort{|a, b| b.semester_scores.find{|sem| sem.semester == 4}.total_score <=> a.semester_scores.find{|sem| sem.semester == 4}.total_score}
    @subjects_2A = @subjects.select{|subject| subject.semester == 4}
    @subject_ids_2A = @subjects_2A.map do |subject|
      subject.id
    end

    @user_scores_3S = @user_scores.sort{|a, b| b.semester_scores.find{|sem| sem.semester == 5}.total_score <=> a.semester_scores.find{|sem| sem.semester == 5}.total_score}
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
