class SessionsController < ApplicationController
   
  def new
    @user = User.new
  end

  def create 
    if auth_hash = request.env['omniauth.auth']
      @user = User.find_or_create_by_omniauth(auth_hash)
      login
    else
      @user = User.find_by(username: params[:username])
      if @user && @user.authenticate(params[:password])
      login
      else
        redirect_to '/login', danger: "Invalid information. Please try again."
      end
    end
  end

  def destroy
    session.destroy
    redirect_to root_url, info: "Logout successful."
  end

  private

  def login
    session[:user_id] = @user.id
    redirect_to user_path(@user)
  end

  def auth
    request.env['omniauth.auth']
  end

end
