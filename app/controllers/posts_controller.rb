class PostsController < ApplicationController
  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      render json: @post, status: :created
    else
      Rails.logger.info(@post.errors.full_messages)
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, tags: [ :tag ])
  end
end
