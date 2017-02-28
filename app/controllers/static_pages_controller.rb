class StaticPagesController < ApplicationController
  def index
  end

  def about
  end

  private
  # Don't check whether the user was authenticated
  def use_before_action?
    false
  end

end
