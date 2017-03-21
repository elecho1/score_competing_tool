class TablesController < ApplicationController
  #callback
  before_action :authenticate_user!
  before_action :registered_scores?, except: :new
  
  def show
    @user_scores = UserScore.all.includes([:user, :scores, :subjects]).order(total_score: :DESC)
    @subjects = Subject.all.order(:id)

    #@subject_ids = Array.new
    #@subject_ids = @subjects.pluck(:id)
    
    @subject_ids = @subjects.map do |subject|
      subject.id
    end

  end 
end
