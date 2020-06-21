class Web::PasswordsController < Web::ApplicationController
  def new
    @password = User.new
  end

  def create
    @user = User.find_by(email: params[:user][:email])

    if @user
      @user.create_password_reset_token
      @user.send_password_reset_email
      flash[:info] = 'Email sent with password reset instructions'
      redirect_to(root_url)
    else
      flash.now[:danger] = 'Email address not found'
      render('new')
    end
  end

  def edit
    @user = User.find_by_password_reset_token(params[:token])
  end

  def update
    @user = User.find_by_password_reset_token(params[:token])

    if @user.update(user_params)
      @user.remove_password_reset_token
      redirect_to(:new_session)
    end
  end

  private

  def user_params
    params[:user].permit(:password, :password_confirmation)
  end
end
