Devise.setup do |config|
  config.mailer_sender = 'please-change-me@example.com'

  # Use ActiveRecord ORM
  require 'devise/orm/active_record'

  # Resolve Google OAuth credentials (ENV first, then credentials)
  google_client_id = (ENV["GOOGLE_CLIENT_ID"] || Rails.application.credentials.dig(:google, :client_id)).to_s.strip
  google_client_secret = (ENV["GOOGLE_CLIENT_SECRET"] || Rails.application.credentials.dig(:google, :client_secret)).to_s.strip

  # Debug log in development to verify .env/credentials loading
  if Rails.env.development?
    masked = google_client_id ? "#{google_client_id[0,6]}…#{google_client_id[-12,12]}" : "(nil)"
    Rails.logger.info("[omniauth] GOOGLE_CLIENT_ID=#{masked}")
    Rails.logger.warn("[omniauth] Google OAuth credentials are missing; login will fail.") if google_client_id.blank? || google_client_secret.blank?
  end

  # OmniAuth (Google)
  config.omniauth :google_oauth2,
                  google_client_id,
                  google_client_secret,
                  {
                    prompt: 'select_account',
                    access_type: 'online',
                    scope: 'email,profile'
                  }

  # You can leave the rest as defaults for now.
end
