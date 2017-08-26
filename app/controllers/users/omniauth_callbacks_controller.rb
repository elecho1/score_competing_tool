class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def slack
    auth = request.env["omniauth.auth"]
    if auth.info.team_id.eql?(ENV['SLACK_TEAM_ID'])
      @user = User.from_omniauth(auth)
    else 
      flash[:alert]="チームIDが間違っています"
      failure()
      return
    end

    if @user.persisted?
      flash[:notice] = "ログインに成功しました。"
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
    #  set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.slack_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
    #binding.pry
    #redirect_to root_path
  end

  def failure
    redirect_to root_path
  end
end
