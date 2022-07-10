class SessionsController < ApplicationController
  def new
  end

  def create
    # Rails tutorialでは、user はローカル変数としている
    # 9.3.1 の演習で、テストから変数にアクセスできるようにするため、インスタンス変数に変更している
    # -> cookiesにユーザーの記憶トークンが正しく含まれているかどうかをテストできるようになる
    # 注釈が付いてるので確認すること
    @user = User.find_by(email: params[:session][:email].downcase)
    # “safe navigation演算子”（または“ぼっち演算子”）を使った例. @user && ~ と書くのと同じ
    if @user&.authenticate(params[:session][:password])
      if @user.activated?
        log_in @user
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        redirect_back_or @user
      else
        message  = "Account not activated."
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
