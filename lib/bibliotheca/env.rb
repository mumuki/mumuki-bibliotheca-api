module Bibliotheca::Env
  class << self
    def atheneum_url
      ENV['MUMUKI_ATHENEUM_URL']
    end

    def atheneum_client_secret
      ENV['MUMUKI_ATHENEUM_CLIENT_SECRET']
    end

    def atheneum_client_id
      ENV['MUMUKI_ATHENEUM_CLIENT_ID']
    end

    def bot_username
      ENV['MUMUKI_BOT_USERNAME']
    end

    def bot_email
      ENV['MUMUKI_BOT_EMAIL']
    end

    def bot_api_token
      ENV['MUMUKI_BOT_API_TOKEN']
    end

    def auth0_client_id
      ENV['MUMUKI_AUTH0_CLIENT_ID']
    end

    def auth0_client_secret
      ENV['MUMUKI_AUTH0_CLIENT_SECRET']
    end

  end
end