class MyscoresController < ApplicationController
  #callback
  def new
    @myscore = UserScore.new
    @myscore.scores.build
    @subjects = Subject.all.order(:id)

    #@subjects = Subject.all.order(:id)
    #@scores
    #@subjects.each do |subject|
    #  score = Score.new
    #  @scores.push(score)
    #end
  end

  # !!!!! バリデーション部要整形 !!!!

  def create
    myscore = UserScore.create(user_score_params)
    update_user_score_info(myscore)
    if myscore.errors.any? 
      flash[:error_num] = myscore.errors.count
      flash[:error_msgs] = myscore.errors.full_messages 
      redirect_to new_myscores_path
    end
    #@myscore = UserScore.new.()
    #@myscore.user = current_user
    #@myscore.gpa = 0

    #@subjects.each do |subject|
    #  score = Score.new
    #  @scores.push(new_score(subject, @myscore))
    #end
  end

  def edit
    @myscore = current_user.user_score
    #@subjects = Subject.all.order(:id)
    @scores = @myscore.scores.order(:subject_id).includes(:subject)
  end
  
  def update
    myscore = current_user.user_score
    @scores = myscore.scores
    scores_params.each do |key, value|
      score = @scores.find(key) #find使わずにSQL文節約可
      unless score.update(value) #たぶん節約できない
        update_user_score_info(myscore)
        flash[:error_num] = score.errors.count + myscore.errors.count
        flash[:error_msgs] = score.errors.full_messages + myscore.errors.full_messages 
        redirect_to edit_myscores_path
      end
    end
    unless update_user_score_info(myscore)
      flash[:error_num] = myscore.errors.count
      flash[:error_msgs] = myscore.errors.full_messages 
      redirect_to edit_myscores_path
    end
  end

  def show
    @myscore = current_user.user_score
    @scores = @myscore.scores.includes(subject: :scores)
    @subjects = @myscore.subjects.order(:id)
    @standings = Hash.new
    @scores.each do |score|
      if score.registered
        #binding.pry
        this_subject_scores = score.subject.scores.where(registered: true).order(value: :DESC)
        stand_count = 1
        this_subject_scores.each do |this_sub_score|
          #binding.pry
          if this_sub_score.value > score.value
            stand_count += 1
          else
            break
          end
        end 
        @standings[score.id] = {standing: stand_count, number: this_subject_scores.size}
      end
    end
  end


  private
  def update_user_score_info(myscore)
    #current_user_score = current_user.user_score
    scores = myscore.scores.where(registered: true)
    myscore.total_score = scores.sum(:value)
    myscore.score_count = scores.count
    if myscore.score_count == 0
      myscore.gpa = 0
    else     
      myscore.gpa = gpa_sum(scores)/myscore.score_count
    end
    #binding.pry
    myscore.save
  end
  
  def gpa_sum(scores)
    sum = 0
    scores.each do |score|
      if score.value >= 90  #優上
        sum += 4.3
      elsif score.value >= 80 #優
        sum += 4.0
      elsif score.value >= 70 #良
        sum += 3.0
      elsif score.value >= 60 #可
        sum += 2.0
      end
    end
    return sum
  end


  def user_score_params
    params.require(:user_score).permit(scores_attributes: [:value, :subject_id, :registered]).merge(user_id: current_user.id, total_score: 0, gpa: 0, score_count:0)
  end

  def scores_params
    #params.require(:score).map { |u| u.permit(:value) }
    params.permit(score: [:value, :registered])[:score]
  end
  
  #def scores_params
  #  params.require(:score).map do |params|
  #    ActionController::Parameters.new(params.to_hash).permit(:value, :id)
  #  end
  #end
  
  
end
