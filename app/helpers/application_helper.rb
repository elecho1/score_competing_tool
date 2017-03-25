module ApplicationHelper
  def score_evaluate(score)
    html=""
    if score >= Constants::YUJYOU_VALUE
      html += <<-BOF1
        <span class="text-darkviolet">優上</span>
      BOF1
    elsif score >= Constants::YU_VALUE
      html += <<-BOF2
        <span class="text-blue">優</span>
      BOF2
    elsif score >= Constants::RYOU_VALUE
      html += <<-BOF3
        <span class="text-lime">良</span>
      BOF3
    elsif score >= Constants::KA_VALUE
      html += <<-BOF4
        <span class="text-orange">可</span>
      BOF4
    else
      html += <<-BOF5
        <span class="text-red">不可</span>
      BOF5
    end
    html.html_safe
  end
  
end
