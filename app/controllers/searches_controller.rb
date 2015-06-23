class SearchesController < ApplicationController

  def index
    if params[:search] == ""
      flash[:error] = 'Cannot submit empty search.'
      redirect_to :back
    end

    if params[:tab].nil?
      search = Sunspot.search(Question, Image) do
        fulltext params[:search] do
          minimum_match min_match_num(params[:search])
        end
        paginate(page: params[:page], per_page: 15)
      end
    elsif params[:tab] == "Questions"
      search = Sunspot.search(Question) do
        fulltext params[:search] do
          minimum_match min_match_num(params[:search])
        end
        paginate(page: params[:page], per_page: 15)
      end
    elsif params[:tab] == "Worksheets"
      search = Sunspot.search(Image) do
        fulltext params[:search] do
          minimum_match min_match_num(params[:search])
        end
        paginate(page: params[:page], per_page: 15)
      end
    end
    @results = search.results

  end

end