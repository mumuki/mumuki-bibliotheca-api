module Bibliotheca::IO
  class AtheneumExporter
    attr_accessor :url, :client_id, :client_secret

    def initialize(url, client_id, client_secret)
      ensure_present! url, client_id, client_secret
      @url = url
      @client_id = client_id
      @client_secret = client_secret
    end

    def self.from_env
      new Bibliotheca::Env.atheneum_url,
          Bibliotheca::Env.atheneum_client_id,
          Bibliotheca::Env.atheneum_client_secret
    end

    def run!(guide)
      RestClient::Resource
        .new(self.class.guides_url(url), client_id, client_secret)
        .post(guide.to_json, {content_type: 'application/json'})
    end

    def self.guides_url(url)
      url += '/' unless url.end_with? '/'
      "#{url}api/guides"
    end

    def self.run!(guide)
      if env_available?
        from_env.run!(guide)
      else
        puts "Warning: Atheneum credentials not set. Not going to export #{guide}"
      end
    end

    private

    def self.env_available?
      Bibliotheca::Env.atheneum_url && Bibliotheca::Env.atheneum_client_id && Bibliotheca::Env.atheneum_client_secret
    end
  end
end
