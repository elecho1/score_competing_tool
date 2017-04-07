# update scores culculating system.

scores = Score.where('id > ?', 7400)

scores.each do |score|
  if score.value.present?
    if score.value >= Constants::YUJYOU_VALUE
      score.value = 95
    elsif score.value >= Constants::YU_VALUE
      score.value = 85
    elsif score.value >= Constants::RYOU_VALUE
      score.value = 75
    elsif score.value >= Constants::KA_VALUE
      score.value = 65
    else
      score.value = 60
    end
    score.save
  end
end

