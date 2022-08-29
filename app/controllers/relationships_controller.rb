class RelationshipsController < ApplicationController
  before_action :logged_in_user   # これがなくても、current_userがnilになるので例外が起こるが、例外を起こさないためにも入れる

  def create
    user = User.find(params[:followed_id])
    current_user.follow(user)
    redirect_to user
  end

  def destroy
    user = Relationship.find(params[:id]).followed
    current_user.unfollow(user)
    redirect_to user
  end
end
