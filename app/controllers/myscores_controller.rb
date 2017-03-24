class MyscoresController < ApplicationController
  #callback
  before_action :authenticate_user!
  before_action :registered_scores?, except: [:new, :create]



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
    @myscore = UserScore.create(user_score_params)
    update_user_score_info(@myscore)
    if @myscore.errors.any? 
      flash[:error_num] = @myscore.errors.count
      flash[:error_msgs] = @myscore.errors.full_messages 
      #redirect_to new_myscores_path
      @subjects = Subject.all.order(:id)
      redirect_to action: :new
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
    #@myscore.scores.build
    #@subjects = Subject.all.order(:id)
    @scores = @myscore.scores.order(:subject_id).includes(:subject)
  end
  
  def update
    @myscore = current_user.user_score
        #binding.pry
    @myscore.update(scores_params)
    update_user_score_info(@myscore)
    if @myscore.errors.any? 
      flash[:error_num] = @myscore.errors.count
      flash[:error_msgs] = @myscore.errors.full_messages 
      #redirect_to new_myscores_path
      @subjects = Subject.all.order(:id)
      render :edit
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
    temp_total_score = 0;
    temp_score_count = 0;
    scores.each do |score|
      temp_total_score += score.value * score.subject.weight
      temp_score_count += score.subject.weight
    end
    #myscore.total_score = scores.sum(:value)
    myscore.total_score = temp_total_score
    #myscore.score_count = scores.count
    myscore.score_count = temp_score_count
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
        sum += 4.3 * score.subject.weight
      elsif score.value >= 80 #優
        sum += 4.0 * score.subject.weight
      elsif score.value >= 70 #良
        sum += 3.0 * score.subject.weight
      elsif score.value >= 60 #可
        sum += 2.0 * score.subject.weight
      end
    end
    return sum
  end


  def user_score_params
    params.require(:user_score).permit(scores_attributes: [:value, :subject_id, :registered]).merge(user_id: current_user.id, total_score: 0, gpa: 0, score_count:0)
  end

  def scores_params
    #params.require(:score).map { |u| u.permit(:value) }
    #params.permit(score: [:value, :registered])[:score]
    params.require(:user_score).permit(scores_attributes: [:value, :subject_id, :registered, :id])
  end
  
  #def scores_params
  #  params.require(:score).map do |params|
  #    ActionController::Parameters.new(params.to_hash).permit(:value, :id)
  #  end
  #end

  def registered_scores?
    if current_user.user_score.blank?
      redirect_to please_register_your_scores_path
      return
    end
  end
  
end
