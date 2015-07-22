class MyClassesController < ApplicationController
  before_action :require_user
  before_action :has_group?, only: [:create]
  before_action :same_school_gategory, only: [:create]

  def create
    @class = MyClass.new(user_id: current_user.id, classable_type: params[:classable_type], classable_id: params[:classable_id])
    if @class.save
      flash[:notice] = "#{@class.classable.name} has been added to your classes."
    else
      flash[:error] = "#{@class.classable.name} is already in your classes list. #{@class.errors.full_messages}"
    end
    redirect_to :back
  end

  def destroy
    current_user.classes.where(classable_type: params[:classable_type], classable_id: params[:classable_id]).destroy_all
    flash[:notice] = "Class has been deleted from MyClass list."
    redirect_to :back
  end

  def info
    flash[:notice] = "To add classes, navigate to your desired class on you're highschool page, than click the 'Add class' button"
    redirect_to (current_user.group ? group_path(current_user.group) : groups_path)

  end


  private

  def same_school_gategory
    if params[:classable_type] == 'Gategory'
      @gategory = Gategory.find(params[:classable_id])
      if @gategory && @gategory.group != current_user.group 
        flash[:error] = "You are not apart of that school."
        redirect_to :back
      end
    end
  end

  def has_group?
    unless current_user.group
      flash[:error] = "Must be apart of a school"
      redirect_to groups_path
    end
  end

end