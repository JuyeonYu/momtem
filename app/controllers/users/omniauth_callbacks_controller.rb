module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def google_oauth2
      auth = request.env['omniauth.auth']
      @user = User.from_omniauth(auth)

      if @user.persisted?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: 'Google') if is_navigational_format?
      else
        redirect_to root_path, alert: '로그인에 실패했습니다.'
      end
    end

    def failure
      redirect_to root_path, alert: '로그인에 실패했습니다.'
    end
  end
end

