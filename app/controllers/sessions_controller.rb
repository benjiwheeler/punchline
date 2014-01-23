class SessionsController < ApplicationController
  def sign_in
  end

  def sign_out
    self.current_user = nil
    redirect_to root_path
  end
end
