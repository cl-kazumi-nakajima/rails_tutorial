class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    respond_to do |format|
      format.html { redirect_to @user }   # これをコメントアウトすると ActionController::UnknownFormat
      format.js   # これをコメントアウトしても、テストは通る。処理の実行はされるが、HTMLが置き換わらないだけ(htmlはあるのでOK)
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end
