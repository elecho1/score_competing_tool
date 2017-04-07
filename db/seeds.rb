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

  def update_user_score_info(myscore)
    #current_user_score = current_user.user_score
    scores = myscore.scores.where(registered: true)
    temp_total_score = 0;
    temp_score_count = 0;
    scores.each do |score|
      temp_total_score += (score.value - Constants::HUKA_VALUE) * score.subject.weight
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
  
user_scores = UserScore.all

user_scores.each do |myscore|
  update_user_score_info(myscore)
end
