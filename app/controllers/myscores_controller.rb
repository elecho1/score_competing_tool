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

  def create
    myscore = UserScore.new(user_score_params)
    myscore.save!
    myscore = update_user_score_info(myscore)
    myscore.save!
    #@myscore = UserScore.new.()
    #@myscore.user = current_user
    #@myscore.gpa = 0

    #@subjects.each do |subject|
    #  score = Score.new
    #  @scores.push(new_score(subject, @myscore))
    #end
  end
  



  private
  #def new_score (subject, myscore)
  #  score = Score.new
  #  score.subject = subject
  #  score.user_score = myscore
  #  return score
  #end


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
    binding.pry
    return myscore
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
  

end
