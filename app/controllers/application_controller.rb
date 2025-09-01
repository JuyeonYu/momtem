class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private

  def require_login
    return if user_signed_in?
    flash[:alert] = '로그인이 필요합니다.'
    redirect_to login_path
  end
end
