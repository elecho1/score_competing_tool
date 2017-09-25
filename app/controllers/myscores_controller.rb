class MyscoresController < ApplicationController
  #callback
  before_action :authenticate_user!
  before_action :registered_scores?, except: [:new, :create]



  def new
    if current_user.user_score.present?
      flash[:already_registered] = "すでに点数は登録されています。"
      redirect_to edit_myscores_path
      return
    end
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
    user_score_params_data = user_score_params
    user_score_params_data[:scores_attributes].each do |key, value|
      unless value.key?(:value) then
        user_score_params_data[:scores_attributes][key][:registered] = "false"
      else
        if value[:registered].eql?("false") then
          user_score_params_data[:scores_attributes][key].delete(:value)
        end   
      end
    end

    @myscore = UserScore.create(user_score_params_data)
    update_user_score_info(@myscore)
    if @myscore.errors.any? 
      flash[:error_num] = @myscore.errors.count
      flash[:error_msgs] = @myscore.errors.full_messages 
      #redirect_to new_myscores_path
      @subjects = Subject.all.order(:id)
      redirect_to action: :new
      return
    end
    #@myscore = UserScore.new.()
    #@myscore.user = current_user
    #@myscore.gpa = 0

    #@subjects.each do |subject|
    #  score = Score.new
    #  @scores.push(new_score(subject, @myscore))
    #end
    redirect_to action: :show
    return
  end

  def edit
    @myscore = current_user.user_score
    #@myscore.scores.build
    #@subjects = Subject.all.order(:id)
    @scores = @myscore.scores.order(:subject_id).includes(:subject)
  end
  
  def update
    scores_params_data = scores_params
    scores_params_data[:scores_attributes].each do |key, value|
      unless value.key?(:value) then
        scores_params_data[:scores_attributes][key][:registered] = "false"
      else
        if value[:registered].eql?("false") then
          scores_params_data[:scores_attributes][key][:value] = nil
        end   
      end
    end
    #@myscore = current_user.user_score.includes(:semester_scores)
    @myscore = current_user.user_score
    @myscore.update(scores_params_data)
    update_user_score_info(@myscore)
    if @myscore.errors.any? 
      flash[:error_num] = @myscore.errors.count
      flash[:error_msgs] = @myscore.errors.full_messages 
      #redirect_to new_myscores_path
      @subjects = Subject.all.order(:id)
      render :edit
      return
    end
    redirect_to action: :show
    return
  end

  def show
    #自分の点数たち
    @myscore = current_user.user_score

    # 総合順位（点数）総合点
    @user_scores = UserScore.all.order(total_score: :DESC)
    stand_count_score = 1
    @user_scores.each do |user_score|
      if user_score.total_score > @myscore.total_score
        stand_count_score += 1
      else
        break
      end
    end
    @total_score_standing = stand_count_score

    # 総合順位（GPA）
    user_scores_gpa = UserScore.all.order(gpa: :DESC)
    stand_count_gpa = 1
    user_scores_gpa.each do |user_score|
      if user_score.gpa > @myscore.gpa
        stand_count_gpa += 1
      else
        break
      end
    end
    @gpa_standing = stand_count_gpa

    ### semester毎の順位
    for num in 4..6 do
      ### 総合順位
      temp_user_scores = @user_scores.sort{|a, b| b.send("sem#{num.to_s}_total_score") <=> a.send("sem"+num.to_s+"_total_score")}
      temp_stand_count_score = 1
      temp_user_scores.each do |user_score|
        if user_score.send("sem"+num.to_s+"_total_score") > @myscore.send("sem"+num.to_s+"_total_score")
          temp_stand_count_score += 1
        else
          break
        end
      end
      var = "@sem#{num.to_s}_total_score_standing"
      eval("#{var} = temp_stand_count_score")
      
      ### GPA
      temp_user_scores_gpa = @user_scores.sort{|a, b| b.send("sem"+num.to_s+"_gpa") <=> a.send("sem"+num.to_s+"_gpa")}
      temp_stand_count_gpa = 1
      temp_user_scores_gpa.each do |user_score|
        if user_score.send("sem"+num.to_s+"_gpa") > @myscore.send("sem"+num.to_s+"_gpa")
          temp_stand_count_gpa += 1
        else
          break
        end
      end
      var = "@sem#{num.to_s}_gpa_standing"
      eval("#{var} = temp_stand_count_gpa")
    end


    
    # 各科目の順位
    @scores = @myscore.scores.includes(subject: :scores)
    @subjects = @myscore.subjects.order(:id)
    @standings = Hash.new
    @scores.each do |score|
      if score.registered
        this_subject_scores = score.subject.scores.where(registered: true).order(value: :DESC)
        stand_count = 1
        this_subject_scores.each do |this_sub_score|
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
    ### total
    scores = myscore.scores.where(registered: true).includes(:subject)
    score_hash = calculate_score(scores)    
    myscore.total_score = score_hash[:total]
    myscore.score_count = score_hash[:count]
    myscore.gpa = score_hash[:gpa]
    myscore.save

    semester_scores = myscore.semester_scores
    for num in 4..6 do
      sem_scores = scores.select{|score| score.subject.semester == num}
      sem_score_hash = calculate_score(sem_scores)
      temp_semester_score = myscore.semester_scores.where(semester: num).first_or_initialize(semester: num)
      # できればここもSQL発行を最適化したい
      temp_semester_score.total_score = sem_score_hash[:total]
      temp_semester_score.score_count = sem_score_hash[:count]
      temp_semester_score.gpa = sem_score_hash[:gpa]
      temp_semester_score.save
    end
      

    ### 2A
    sem4_scores = scores.select{|score| score.subject.semester == 4}
    sem4_score_hash = calculate_score(sem4_scores)    
    myscore.sem4_total_score = sem4_score_hash[:total]
    myscore.sem4_score_count = sem4_score_hash[:count]
    myscore.sem4_gpa = sem4_score_hash[:gpa]
    ### 3S
    sem5_scores = scores.select{|score| score.subject.semester == 5}
    sem5_score_hash = calculate_score(sem5_scores)    
    myscore.sem5_total_score = sem5_score_hash[:total]
    myscore.sem5_score_count = sem5_score_hash[:count]
    myscore.sem5_gpa = sem5_score_hash[:gpa]
    ### 3A
    sem6_scores = scores.select{|score| score.subject.semester == 6}
    sem6_score_hash = calculate_score(sem6_scores)    
    myscore.sem6_total_score = sem6_score_hash[:total]
    myscore.sem6_score_count = sem6_score_hash[:count]
    myscore.sem6_gpa = sem6_score_hash[:gpa]

    myscore.save
  end

  def calculate_score(scores)
    calculate_hash = {}
    temp_total_score = 0;
    temp_score_count = 0;
    scores.each do |score|
      temp_total_score += (score.value - Constants::HUKA_VALUE) * score.subject.weight
      temp_score_count += score.subject.weight
    end
    calculate_hash[:total] = temp_total_score
    calculate_hash[:count] = temp_score_count
    
    ### gpa
    if calculate_hash[:count] == 0
      calculate_hash[:gpa] = 0
    else
      calculate_hash[:gpa] = gpa_sum(scores)/calculate_hash[:count]
    end

    return calculate_hash
  end
  
  def gpa_sum(scores)
    sum = 0
    scores.each do |score|
      if score.value >= Constants::YUJYOU_VALUE  #優上
        sum += 4.3 * score.subject.weight
      elsif score.value >= Constants::YU_VALUE #優
        sum += 4.0 * score.subject.weight
      elsif score.value >= Constants::RYOU_VALUE #良
        sum += 3.0 * score.subject.weight
      elsif score.value >= Constants::KA_VALUE #可
        sum += 2.0 * score.subject.weight
      end
    end
    return sum
  end


  def user_score_params
    params.require(:user_score).permit(scores_attributes: [:value, :subject_id, :registered]).merge(user_id: current_user.id, total_score: 0, gpa: 0, score_count:0, sem4_total_score: 0, sem4_gpa: 0, sem4_score_count: 0, sem5_total_score: 0, sem5_gpa: 0, sem5_score_count: 0, sem6_total_score: 0, sem6_gpa: 0, sem6_score_count: 0,)
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
