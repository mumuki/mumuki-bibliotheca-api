module Bibliotheca::IO
  class AtheneumExporter
    attr_accessor :url, :user, :password

    def initialize(url, user, password)
      @url = url
      @user = user
      @password = password
    end

    def self.new_from_env
      new ENV['ATHENEUM_URL'], ENV['ATHENEUM_USER'], ENV['ATHENEUM_PASSWORD']
    end

    def run!(guide)
      RestClient::Request.execute(method: :post, url: url, user: user, password: password, payload: guide)
    end
  end
end
