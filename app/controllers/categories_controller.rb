class CategoriesController < ApplicationController

  def index
    @categories = Category.where(master_id: nil)
    @users = User.order('votes_count DESC').limit(10)

    if params[:tab].nil?
      @image = Image.new
      @images = Image.all
      @images = sub_tab(@images)
    elsif params[:tab] == "Questions"
      @question = Question.new
      @questions = Question.all
      @questions = sub_tab(@questions)
    elsif params[:tab] == "Answers" 
      @unanswered = Question.where(answered: nil)
      @unanswered = sub_tab(@unanswered)
    end
  end
 
  def show
    @category = Category.find(params[:id])
    @users = User.order('votes_count DESC').limit(10)

    if params[:tab].nil?
      @image = Image.new(categories: @category.ancestor_objects)
      @images = Image.joins(:categories).where("categories.id == '#{@category.id}'")
      @images = sub_tab(@images)
    elsif params[:tab] == "Questions"
      @question = Question.new(categories: @category.ancestor_objects)
      @questions = Question.joins(:categories).where("categories.id == '#{@category.id}'")
      @questions = sub_tab(@questions)
    elsif params[:tab] == "Answers" 
      @unanswered = Question.where(answered: nil).joins(:categories).where("categories.id == '#{@category.id}'")
      @unanswered = sub_tab(@unanswered)
    end
  end

  def new
    @category = Category.new(master_id: params[:master_id])
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      flash[:notice] = "Category has been created"
      redirect_to category_path(@category)
    else
      render :new
    end
  end

  def search
    @category = Category.find(params[:id])
    if params[:search_category] == ""
      flash[:error] = 'Cannot submit empty search.'
      redirect_to :back
    end

    if params[:tab].nil?
      search = Sunspot.search(Question, Image) do
        with(:category_ids, params[:id])
        fulltext params[:search_category] do
          minimum_match min_match_num(params[:search_category])
        end
        paginate(page: params[:page], per_page: 15)
      end
    elsif params[:tab] == "Questions"
      search = Sunspot.search(Question) do
        with(:category_ids, params[:id])
        fulltext params[:search_category] do
          minimum_match min_match_num(params[:search_category])
        end
        paginate(page: params[:page], per_page: 15)
      end
    elsif params[:tab] == "Worksheets"
      search = Sunspot.search(Image) do
        with(:category_ids, params[:id])
        fulltext params[:search_category] do
          minimum_match min_match_num(params[:search_category])
        end
        paginate(page: params[:page], per_page: 15)
      end
    end
        
    @results = search.results
  end


  private

  def category_params
    params.require(:category).permit!
  end
end