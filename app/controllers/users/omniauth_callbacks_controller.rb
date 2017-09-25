class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def slack
    auth = request.env["omniauth.auth"]
    if auth.info.team_id.eql?(ENV['SLACK_TEAM_ID'])
      @user = User.from_omniauth(auth)
    else 
      flash[:alert]="チームIDが間違っています。あなたのチームIDは#{auth.info.team_id}です。"
      redirect_to root_path
      return
    end

    if @user.persisted?
      sign_in @user, :event => :authentication
      if @user.slack_enabled_flag
        flash[:notice] = "ログインに成功しました。"
        redirect_to root_path
      else 
        flash[:notice] = "引き続きアカウント情報を登録してください。"
        redirect_to edit_user_registration_path
        #redirect_to root_path
      end
      
      #sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
    #  set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      #session["devise.slack_data"] = request.env["omniauth.auth"]
      #redirect_to new_user_registration_url
      failure()
    end
    #binding.pry
    #redirect_to root_path
  end

  def failure
    flash[:alert] = "ログインに失敗しました。"
    redirect_to root_path
  end
end
