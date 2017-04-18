class UsersController < ApplicationController
  #callback
  before_action :authenticate_user!

  def profile
    @user = current_user
  end
  
end
