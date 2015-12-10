module Bibliotheca::IO
  class AtheneumExporter
    attr_accessor :url

    def initialize(url)
      @url = url
    end

    def self.new_from_env
      new(ENV['ATHENEUM_URL'])
    end

    def run!(guide)
      RestClient::Request.execute(method: :post, url: @url, user: ENV['ATHENEUM_USER'], password: ENV['ATHENEUM_PASSWORD'], payload: guide)
    end
  end
end
