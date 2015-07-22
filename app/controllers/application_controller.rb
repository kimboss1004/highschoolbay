class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :prepare_for_mobile
  helper_method :current_user, :logged_in?, :require_user, :creator?, :member?, :seperate_array_tri, :branched_descendents, :autofocus?, :mobile_device?

  def current_user
    current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_user
    unless logged_in?
      flash[:error] = "Must be logged in to access that page"
      redirect_to login_path(log_return: (request.fullpath == questions_path || request.fullpath == images_path ? root_path : request.fullpath))
    end
  end

  def require_user_vote
    unless logged_in?
      request.format = :mobilejs if mobile_device?
      render 'votes/require_user'
    end  
  end

  def creator?(user_id)
    current_user.id == user_id.to_i
  end

  def member?(group_id)
    if current_user.group
      return !!(current_user.group.id == group_id.to_i)
    else
      return false
    end
    
  end

  def dynamic_post_path(params, tab)
    if (params[:group] == "") && (params[:category] == "") && (params[:gategory] == "")
      return root_path(tab: tab)
    elsif (params[:group] == "") && !(params[:category] == "") && (params[:gategory] == "")
      return category_path(params[:category].to_i, tab: tab)
    elsif !(params[:group] == "") && (params[:category] == "") && (params[:gategory] == "")
      return group_path(params[:group].to_i, tab: tab)
    elsif !(params[:group] == "") && !(params[:category] == "") && (params[:gategory] == "")
      return group_category_path(params[:group].to_i, params[:category].to_i, tab: tab)
    elsif !(params[:group] == "") && !(params[:gategory] == "")
      return group_gategory_path(params[:group].to_i, params[:gategory].to_i, tab: tab)
    end
  end

  def sub_tab(objects)
    if params[:sub_tab].nil?
      objects = objects.order('created_at desc')
    elsif params[:sub_tab] == "Popular"
      objects = objects.where(:created_at => 2.weeks.ago..DateTime.now.end_of_day).order('views desc').order('created_at desc')
    elsif params[:sub_tab] == "Favorite"
      objects = objects.where(:created_at => 2.weeks.ago..DateTime.now.end_of_day).order('votes_count desc').order('created_at desc')
    end
    return objects.page(params[:page]).per(15)
  end

  def min_match_num(str)
    num = (str.split.size) - (str.split.size)/2
    return num
  end

  def seperate_array_tri(i, array)
    product = []
    while(i < array.size)
      product << array[i]
      i = i + 3
    end
    return product
  end


 def branched_descendents(category)
  total_gategories = []
  total_gategories << all_gategories([category])
  next_generation = category_children([category])
  total_gategories << all_gategories(next_generation)
  while next_generation.any?
    next_generation = category_children(next_generation)
    total_gategories << all_gategories(next_generation)
  end
  return total_gategories.flatten
 end

 def all_gategories(categories)
   total_gategories = []
   if categories.any?
    categories.each do |category|
      total_gategories << category.gategories
      category.gategories.each do |gategory|
        total_gategories << gategory.descendents
      end
    end
   end

   return total_gategories.flatten

 end

 def category_children(next_generation)
  output = []
  next_generation.each do |individual|
    output << individual.sub_categories      
  end
  return output.flatten
 end

 def autofocus?(url)
  if url == login_path || url == register_path || url == new_group_path
    return false
  else
    true
  end 
 end

 def mobile_device?
  if session[:mobile_param]
    session[:mobile_param] == "1"
  else
    request.user_agent =~ /Mobile|webOS/
  end
 end

 def prepare_for_mobile
    session[:mobile_param] = params[:mobile] if params[:mobile]
    request.format = :mobile if mobile_device?
 end

 def group_nav
  @group_nav = true
 end

  
end
