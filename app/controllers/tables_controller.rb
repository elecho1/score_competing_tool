class TablesController < ApplicationController
  def show
    @user_scores = UserScore.all.includes([:user, :scores, :subjects]).order(total_score: :DESC)
    @subjects = Subject.all.order(:id)
  end 
end
