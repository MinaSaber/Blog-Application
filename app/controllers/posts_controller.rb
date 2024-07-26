class PostsController < ApplicationController
  before_action :set_post, only: [ :show, :update, :destroy ]
  before_action :authorize_user!, only: [ :update, :destroy ]

  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      render json: @post.custom_post_parameters, status: :created
    else
      Rails.logger.info(@post.errors.full_messages)
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def index
    render json: Post.all.map(&:custom_post_parameters)
  end

  def show
    render json: @post.custom_post_parameters
  end

  def update
    if @post.update(post_params)
      render json: @post.custom_post_parameters, status: :ok
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    head :no_content
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def authorize_user!
    unless @post.user == current_user
      render json: { error: "You are not authorized to perform this action." }, status: :forbidden
    end
  end

  def post_params
    params.require(:post).permit(:title, :body, tags_attributes: [ :id, :tag, :_destroy ])
  end
end
