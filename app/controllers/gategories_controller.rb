class GategoriesController < ApplicationController
  before_action :require_user, only: [:new, :create]
  before_action :require_member, only: [:new, :create]

  def new
    @parent = (params[:category_id] ? Category.find(params[:category_id].to_i) : Gategory.find(params[:gategory_id].to_i))
    @group = Group.find(params[:group_id])
    @gategory = Gategory.new
  end

  def create
    @gategory = Gategory.new(gategory_params)
    @group = Group.find(params[:group_id])
    @gategory.group = @group
    @parent = (params[:gategory].include?(:master_id) ? Category.find(params[:gategory][:master_id].to_i) : Gategory.find(params[:gategory][:gmaster_id].to_i))

    if @gategory.save
      flash[:notice] = "#The category {@gategory.name} has been created."
      redirect_to group_gategory_path(@group, @gategory)
    else
      render :new
    end
  end

  def show
    @group = Group.find(params[:group_id])
    @gategory = Gategory.find(params[:id])
    @category = @gategory.master_category
    @users = User.where(group_id: @group).order('votes_count DESC').limit(10)

    if params[:tab].nil?
      @question = Question.new(categories: @category.ancestor_objects, gategories: @gategory.ancestor_gategories)
      @questions = Question.joins(:gategories).where("gategories.id == '#{@gategory.id}'")
      @questions = sub_tab(@questions)
    elsif params[:tab] == "Worksheets"
      @image = Image.new(categories: @category.ancestor_objects, gategories: @gategory.ancestor_gategories)
      @images = Image.joins(:gategories).where("gategories.id == '#{@gategory.id}'")
      @images = sub_tab(@images)
    elsif params[:tab] == "Answers" 
      @unanswered = Question.where(answered: nil).joins(:gategories).where("gategories.id == '#{@gategory.id}'")
      @unanswered = sub_tab(@unanswered)
    end
  end

  def search
    @group = Group.find(params[:group_id])
    @gategory = Gategory.find(params[:id])
    if params[:search_gategory] == ""
      flash[:error] = 'Cannot submit empty search.'
      redirect_to :back
    end

    if params[:tab].nil?
      search = Sunspot.search(Question, Image) do
        with(:gategory_ids, params[:id])
        fulltext params[:search_gategory] do
          minimum_match min_match_num(params[:search_gategory])
        end
        paginate(page: params[:page], per_page: 15)
      end
    elsif params[:tab] == "Questions"
      search = Sunspot.search(Question) do
        with(:gategory_ids, params[:id])
        fulltext params[:search_gategory] do
          minimum_match min_match_num(params[:search_gategory])
        end
        paginate(page: params[:page], per_page: 15)
      end
    elsif params[:tab] == "Worksheets"
      search = Sunspot.search(Image) do
        with(:gategory_ids, params[:id])
        fulltext params[:search_gategory] do
          minimum_match min_match_num(params[:search_gategory])
        end
        paginate(page: params[:page], per_page: 15)
      end
    end
        
    @results = search.results
  end


  private

  def require_member
    unless member?(params[:group_id])
      flash[:error] = "You must be a member of that school."
      redirect_to :back
    end
  end

  def gategory_params
    params.require(:gategory).permit(:name,:master_id,:gmaster_id)
  end

end