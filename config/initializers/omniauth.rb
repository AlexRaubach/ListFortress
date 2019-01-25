require 'omniauth-slack'
Rails.application.config.middleware.use OmniAuth::Builder do
  #provider :google_oauth2, ENV['google_client_id'], ENV['gooogle_client_secret']
  provider :slack, ENV['slack_client_id'], ENV['slack_client_secret'], scope: 'identity.basic identity.email identity.team identity.avatar', team: 'T2FCSKL3Z'
end
