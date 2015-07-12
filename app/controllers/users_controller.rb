class UsersController < ApplicationController
  before_action :require_user, only: [:edit,:update, :notifications]
  before_action :can_user_edit_account, only: [:edit,:update, :notifications]

  def index
    
  end
 
  def show
    @user = User.find(params[:id])
    @rank =  User.where(group_id: @user.group).order('votes_count desc').index{ |user| user.id == @user.id } + 1

    if params[:tab].nil?
      @questions = Question.where(user_id: @user).order('created_at desc').page(params[:page]).per(30)
    elsif params[:tab] == "Worksheets"
      @images = Image.where(user_id: @user).order('created_at desc').page(params[:page]).per(30)
    elsif params[:tab] == "Answers"
      @answers = Comment.where(user_id: @user, commentable_type: "Question").order('created_at desc').page(params[:page]).per(30)
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:notice] = "You have succesfully registered!"
      redirect_to groups_path
    else
      render :new
    end 
  end

  def edit
    @user = User.find(current_user.id)
  end  

  def update
    @user = User.find(current_user.id)
    if @user.update(user_params)
      flash[:notice] = "Your account has been updated"
      redirect_to root_path
    else
      render :edit
    end
  end

  def member
    @user = current_user
    old_group = current_user.group

    @user.update(group_id: params[:group_id])

    if @user.group
      flash[:notice] = "You are a now member of #{@user.group.school}."
    else
      @user.classes.destroy_all
      flash[:error] = "You have left #{old_group.school}."
    end
    redirect_to :back
  end

  def notifications
    @notifications = current_user.notifications.order('created_at desc').page(params[:page]).per(30)

    render :notifications

    @notifications.where(checked: nil).update_all(checked: true, checked_at: Time.now)
  end



private
  def can_user_edit_account
    unless creator?((params[:id]))
      flash[:error] = "That is not your account!"
      redirect_to root_path
    end
  end

  def user_params
    params.require(:user).permit(:username,:password,:password_confirmation,:group_id)
  end



end