module Bibliotheca::IO
  class AtheneumExporter
    attr_accessor :url, :user, :password

    def initialize(url, user, password)
      @url = url
      @user = user
      @password = password
    end

    def self.new_from_env
      new atheneum_url, atheneum_user, atheneum_password
    end

    def run!(guide)
      RestClient::Resource
        .new(self.class.guides_url(url), user, password)
        .post(guide.to_json, {content_type: 'application/json'})
    end

    def self.guides_url(url)
      url += '/' unless url.end_with? '/'
      "#{url}api/guides"
    end

    def self.run!(guide)
      if atheneum_url
        new_from_env.run!(guide)
      else
        puts "Warning: Atheneum credentials not set. Not going to export #{guide}"
      end
    end

    private

    def self.atheneum_url
      ENV['ATHENEUM_URL']
    end

    def self.atheneum_password
      ENV['ATHENEUM_PASSWORD']
    end

    def self.atheneum_user
      ENV['ATHENEUM_USER']
    end
  end
end
