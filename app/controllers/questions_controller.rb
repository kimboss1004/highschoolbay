class QuestionsController < ApplicationController
  before_action :require_user, only: [:new, :create]
  before_action :require_user_vote, only: [:vote]

  def show
    @question = Question.find(params[:id])
    impressionist(@question, nil, :unique => [:session_hash])
    @comments = Comment.where(commentable_type: 'Question', commentable_id: @question.id).order('created_at DESC')
    @best_answer = @comments.sort_by {|comment| comment.votes_count }.last
    @comment = Comment.new
  end

  def new
    @question = Question.new
    if params[:mobile_category]
      @queston.category_ids = params[:mobile_category].to_i
    end
  end

  def create
    @question = Question.new(question_params)
    @group = Group.find(params[:group] ? params[:group].to_i : current_user.group_id)
    @question.group = @group
    @question.user = current_user
    if @question.save
      flash[:notice] = "Your question has been submitted."
      redirect_to dynamic_post_path(params, nil)
    else
      render :new
    end
  end

  def vote
    @question = Question.find(params[:id])
    @vote = Vote.find_by(voteable: @question, user_id: current_user.id)

    if !@vote
      Vote.create(vote: params[:vote], user_id: current_user.id, voteable: @question)
    elsif @vote.vote.to_s == params[:vote]
      return nil
    else 
      @vote.update(vote: params[:vote])
    end

    respond_to do |format|
      format.js
    end
  end


  private

  def question_params
    params.require(:question).permit!
  end

end