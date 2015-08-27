class GroupsController < ApplicationController
  before_action :require_user, only: [:new, :create]
  before_action :group_nav, only: [:category, :show, :search]
  helper_method :seperate_array_two
 
  def index
    #2d array [[], [], []]
    @schools = state_schools_array
    @title = "Find School"
  end

  def category 
    @group = Group.find(params[:group_id])
    @category = Category.find(params[:id])
    @title = "#{@category.name} | #{upcase_first(@group.school)}"
    @gategories = @category.gategories.where(group_id: params[:group_id])
    @users = User.where(group_id: @group).order('votes_count DESC').limit(10)

    if params[:tab].nil?
      @image = Image.new(categories: @category.ancestor_objects)
      @images = Image.where(group_id: @group).joins(:categories).where("categories.id = '#{@category.id}'")
      @images = sub_tab(@images)
    elsif params[:tab] == "Questions"
      @question = Question.new(categories: @category.ancestor_objects)
      @questions = Question.where(group_id: @group).joins(:categories).where("categories.id = '#{@category.id}'")
      @questions = sub_tab(@questions)
    elsif params[:tab] == "Answers" 
      @unanswered = Question.where(group_id: params[:group_id], answered: nil).joins(:categories).where("categories.id = '#{@category.id}'")
      @unanswered = sub_tab(@unanswered)
    end
  end

  def show
    @group = Group.find(params[:id])
    @title = upcase_first(@group.school)
    @users = User.where(group_id: @group).order('votes_count DESC').limit(10)

    if params[:tab].nil?
      @image = Image.new
      @images = Image.where(group_id: @group)
      @images = sub_tab(@images)
    elsif params[:tab] == "Questions"
      @question = Question.new
      @questions = Question.where(group_id: @group)
      @questions = sub_tab(@questions)
    elsif params[:tab] == "Answers" 
      @unanswered = Question.where(group_id: @group,answered: nil)
      @unanswered = sub_tab(@unanswered)
    end

  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      flash[:notice] = "#{@group.school} has been added to HighschoolBay!"
      redirect_to groups_path
    else
      render :new
    end
  end



  def search
    @group = Group.find(params[:id])
    @title = "#{params[:search_group]} | #{upcase_first(@group.school)}"
    if params[:search_group] == ""
      flash[:error] = 'Cannot submit empty search.'
      redirect_to :back
    end

    if params[:tab].nil?
      search = Sunspot.search(Question, Image) do
        with(:group_id, params[:id])
        fulltext params[:search_group] do
          minimum_match min_match_num(params[:search_group])
        end
        paginate(page: params[:page], per_page: 15)
      end
    elsif params[:tab] == "Questions"
      search = Sunspot.search(Question) do
        with(:group_id, params[:id])
        fulltext params[:search_group] do
          minimum_match min_match_num(params[:search_group])
        end
        paginate(page: params[:page], per_page: 15)
      end
    elsif params[:tab] == "Worksheets"
      search = Sunspot.search(Image) do
        with(:group_id, params[:id])
        fulltext params[:search_group] do
          minimum_match min_match_num(params[:search_group])
        end
        paginate(page: params[:page], per_page: 15)
      end
    end
        
    @results = search.results
  end


  def search_group_category
    @group = Group.find(params[:group_id])
    @category = Category.find(params[:id])
    @title = "#{params[:search_group_category]} | #{@category.name} | #{upcase_first(@group.school)}"
    if params[:search_group_category] == ""
      flash[:error] = 'Cannot submit empty search.'
      redirect_to :back
    end

    if params[:tab].nil?
      search = Sunspot.search(Question, Image) do
        with(:group_id, params[:group_id])
        with(:category_ids, params[:id])
        fulltext params[:search_group_category] do
          minimum_match min_match_num(params[:search_group_category])
        end
        paginate(page: params[:page], per_page: 15)
      end
    elsif params[:tab] == "Questions"
      search = Sunspot.search(Question) do
        with(:group_id, params[:group_id])
        with(:category_ids, params[:id])
        fulltext params[:search_group_category] do
          minimum_match min_match_num(params[:search_group_category])
        end
        paginate(page: params[:page], per_page: 15)
      end
    elsif params[:tab] == "Worksheets"
      search = Sunspot.search(Image) do
        with(:group_id, params[:group_id])
        with(:category_ids, params[:id])
        fulltext params[:search_group_category] do
          minimum_match min_match_num(params[:search_group_category])
        end
        paginate(page: params[:page], per_page: 15)
      end
    end
        
    @results = search.results
  end


  def search_school_index
    if params[:search_index_school] == "" && params[:search_index_state] == "" && params[:search_index_city] == ""
      flash[:error] = 'Cannot submit empty search.'
      redirect_to :back
    end
    search = Group.search do
      any do
        fulltext params[:search_index_school], :fields => :school
        fulltext params[:search_index_state], :fields => :state
        fulltext params[:search_index_city], :fields => :city
      end
      paginate(page: params[:page], per_page: 15)
    end
    @results = search.results
  end




  def seperate_array_two(i, array)
    product = []
    while(i < array.size)
      product << array[i]
      i = i + 2
    end
    return product
  end

  private

  def state_schools_array
    state_schools_array = []
    us_states.each do |state| 
      state_schools = []
      state_schools = Group.where(state: state).order('city ASC').flatten
      if state_schools.any?
        state_schools_array << state_schools
      end 
    end
    return state_schools_array
  end

  def us_states
      [
        'Alabama','Alaska','Arizona','Arkansas','California','Colorado','Connecticut','Delaware','District of Columbia',
        'Florida','Georgia', 'Hawaii', 'Idaho', 'Illinois','Indiana', 'Iowa', 'Kansas', 'Kentucky', 'Louisiana', 'Maine',
        'Maryland', 'Massachusetts','Michigan', 'Minnesota', 'Mississippi', 'Missouri', 'Montana', 'Nebraska', 'Nevada', 
        'New Hampshire','New Jersey', 'New Mexico', 'New York', 'North Carolina','North Dakota', 'Ohio', 'Oklahoma', 'Oregon', 
        'Pennsylvania', 'Puerto Rico', 'Rhode Island', 'South Carolina', 'South Dakota', 'Tennessee', 'Texas', 'Utah', 'Vermont', 
        'Virginia', 'Washington', 'West Virginia', 'Wisconsin', 'Wyoming'
      ]
  end

  def group_params
    params[:group][:school].downcase!
    params[:group][:city].downcase!
    params.require(:group).permit(:school,:state,:city)
  end
end