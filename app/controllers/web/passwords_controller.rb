class Web::PasswordsController < Web::ApplicationController
  def new
    @password = User.new
  end

  def create
    @user = User.find_by(email: params[:user][:email])

    if @user
      @user.create_password_reset_token
      UserMailer.password_reset(@user).deliver_now
      flash[:info] = 'Email sent with password reset instructions'
      redirect_to :root_url
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

    if !@user
      flash.now[:danger] = 'User not found'
      render('new')
    else
      @user.update(user_params)
      @user.remove_password_reset_token
      flash[:info] = 'Password succesful update'
      redirect_to(:new_session)
    end
  end

  private

  def user_params
    params[:user].permit(:password, :password_confirmation)
  end
end
