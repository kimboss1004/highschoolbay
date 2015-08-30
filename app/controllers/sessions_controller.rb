class SessionsController < ApplicationController
  before_action :require_user, only: [:destroy]
 
  def new
    if params[:log_return]
      session[:log_return] = params[:log_return]
    end
    @title = "Login"
    
  end

  def create
    user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id 
      flash[:notice] = "#{user.username}, you have logged in."
      redirect_to (session[:log_return] ? session[:log_return] : root_path)
    else
      flash[:error] = " Incorrect username or password."
      render :new
      flash[:error] = nil
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "You have logged out."
    redirect_to root_path
  end

end