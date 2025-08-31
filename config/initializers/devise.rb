Devise.setup do |config|
  config.mailer_sender = 'please-change-me@example.com'

  # Use ActiveRecord ORM
  require 'devise/orm/active_record'

  # OmniAuth (Google)
  config.omniauth :google_oauth2,
                  ENV.fetch('GOOGLE_CLIENT_ID', nil),
                  ENV.fetch('GOOGLE_CLIENT_SECRET', nil),
                  {
                    prompt: 'select_account',
                    access_type: 'online',
                    scope: 'email,profile'
                  }

  # You can leave the rest as defaults for now.
end

