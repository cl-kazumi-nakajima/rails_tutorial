class ApplicationController < ActionController::Base
  def hello
    render html: "hello, worlld!"
  end
end
