class DistributionGraphsController < ApplicationController
  def show
    #subjects = Subject.all.includes(:scores).where("scores.registered = ?", true).references(:scores).order(:id)
    @subjects = Subject.all.includes(:scores).order(:id)
    @subject_eval_count = Hash.new

    @subjects.each do |subject|
      yujyou_count = 0
      yu_count = 0
      ryou_count = 0
      ka_count = 0
      huka_count = 0
      mijyukou_count = 0

      subject.scores.each do |score|
        if score.registered == false #未受講
          mijyukou_count += 1
        elsif score.value >= Constants::YUJYOU_VALUE #優上
          yujyou_count += 1
        elsif score.value >= Constants::YU_VALUE #優
          yu_count += 1
        elsif score.value >= Constants::RYOU_VALUE #良
          ryou_count += 1
        elsif score.value >= Constants::KA_VALUE #可
          ka_count += 1
        else
          huka_count += 1
        end
      end

      @subject_eval_count[subject.id] = {mijyukou_count: mijyukou_count, yujyou_count: yujyou_count, yu_count: yu_count, ryou_count: ryou_count, ka_count: ka_count, huka_count: huka_count}
      
    end

  end
end
