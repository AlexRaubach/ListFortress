ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'webmock/minitest'

# Tests must never hit tabletop.to, Best Coast Pairings or the squad builders.
WebMock.disable_net_connect!(allow_localhost: true)

OmniAuth.config.test_mode = true

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def fixture_file(name)
    Rails.root.join('test/fixtures/files', name).read
  end
end

class ActionDispatch::IntegrationTest
  # The default www.example.com host would hit the www -> apex redirect in routes.rb.
  setup { host! 'example.com' }

  # Signs in through the real omniauth callback using a mocked Slack response.
  def sign_in_as(user)
    # Signing in while already signed in links accounts instead, so start fresh.
    get '/logout'
    uid = "slack-#{user.id}"
    Identity.create!(uid: uid, provider: 'slack', user: user)
    OmniAuth.config.mock_auth[:slack] = OmniAuth::AuthHash.new(provider: 'slack', uid: uid)
    get '/auth/slack/callback'
  end

  teardown do
    OmniAuth.config.mock_auth[:slack] = nil
  end
end
