module RequestHelpers
  # テストユーザーがログイン中の場合にtrueを返す
  # リクエストスペックであればsession変数もそのまま使える
  def is_logged_in?
    !session[:user_id].nil?
  end
end
