class ImagesController < ApplicationController
  before_action :require_user, only: [:new, :create, :show]
  before_action :too_poor?, only: [:show]
  before_action :require_user_vote, only: [:vote]


  def show
    impressionist(@image, nil, :unique => [:session_hash])
    @comments = Comment.where(commentable_type: 'Image', commentable_id: @image.id).order('created_at DESC')
    @comment = Comment.new
    @title = "#{@image.title} | Worksheet"
    render :show
    flash[:value] = nil
  end

  def new
    @image = Image.new
  end

  def create
    @image = Image.new(image_params)
    if !params[:group].nil? && params[:group] != ""
      @group = Group.find(params[:group].to_i)
    else
      @group = current_user.group
    end
    @image.group = @group
    @image.user = current_user

    if params[:photos] && @image.save
      params[:photos].each { |photo|
        @image.pictures.create(photo: photo)
      }
      flash[:notice] = "Your image has been submitted."
      flash['value'] = "+25pts. Current total: #{current_user.votes_count}pts"
      redirect_to dynamic_post_path(params, nil)
    else
      @image.valid?
      if !params[:photos]
        flash[:error] = "Must select a photo."
      end
      render :new
    end
  end

  def vote
    @image = Image.find(params[:id])
    @vote = Vote.find_by(voteable: @image, user_id: current_user.id)

    if !@vote
      Vote.create(vote: params[:vote], user_id: current_user.id, voteable: @image)
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

  def image_params
    params.require(:image).permit!
  end

  def too_poor?
    @image = Image.find(params[:id])
      unless session["Image#{params[:id]}"] || @image.user == current_user
        if current_user.votes_count < 5
          flash[:error] = "Need at least 5pts. Current total: #{current_user.votes_count}pts. Search highschoolbay.com/guide for more info."
          redirect_to :back
        else
          current_user.update(votes_count: (current_user.votes_count - 5))
          session["Image#{params[:id]}"] = true
          flash[:value] = "-5pts. Current total: #{current_user.votes_count}pts"
        end


      end
  end


end