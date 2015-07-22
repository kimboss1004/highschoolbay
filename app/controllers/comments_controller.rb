class CommentsController < ApplicationController
  before_action :require_user_comments, only: [:create]
  before_action :require_user_vote, only: [:vote]

  def create
    if params[:question_id]
      @question = Question.find(params[:question_id])
      @comment = @question.comments.new(comment_params)
      @comment.group_id = current_user.group_id
      @comment.user = current_user

      if @comment.save
        if !(@question.answered)
          @question.update(answered: true)
        end
        flash[:notice] = "Your answer has been submitted"
      else
        flash[:error] = "Answer cannot be empty."
      end

    else
      @image = Image.find(params[:image_id])
      @comment = @image.comments.new(comment_params)
      @comment.group_id = current_user.group_id
      @comment.user = current_user
      if @comment.save
        flash[:notice] = "Your comment has been submitted"
      else
        flash[:error] = "Comment cannot be empty."
      end
    end

    redirect_to :back
  end

  def vote
    @comment = Comment.find(params[:id])
    @vote = Vote.find_by(voteable: @comment, user_id: current_user.id)

    if !@vote
      Vote.create(vote: params[:vote], user_id: current_user.id, voteable: @comment)
    elsif @vote.vote.to_s == params[:vote]
      return nil
    else 
      @vote.update(vote: params[:vote])
    end
    
    request.format = :mobilejs if mobile_device?

    respond_to do |format|
      format.js
      format.mobilejs
    end
  end


  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def require_user_comments
    unless logged_in?
      flash[:error] = "Must be logged in to access that page"
      redirect_to :back
    end
  end


end