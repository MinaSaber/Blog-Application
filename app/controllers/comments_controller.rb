class CommentsController < ApplicationController
  before_action :set_post
  before_action :authenticate_user!
  before_action :set_comment, only: [ :update, :destroy ]
  before_action :authorize_comment!, only: [ :update, :destroy ]

  def create
    @comment = @post.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      render json: @comment.custom_comment_parameters, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def update
    if @comment.update(comment_params)
      render json: @comment.custom_comment_parameters, status: :ok
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    head :no_content
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = @post.comments.find(params[:id])
  end

  def authenticate_user!
    unless current_user
      render json: { message: "Please log in" }, status: :unauthorized
    end
  end

  def authorize_comment!
    unless @comment.user == current_user
      render json: { message: "You are not authorized to perform this action." }, status: :forbidden
    end
  end

  def comment_params
    params.require(:comment).permit(:comment)
  end
end
