module Bibliotheca::IO
  class AtheneumExporter
    attr_accessor :url, :client_id, :client_secret, :kind

    def initialize(kind, url, client_id, client_secret)
      ensure_present! kind, url, client_id, client_secret
      @kind = kind
      @url = url
      @client_id = client_id
      @client_secret = client_secret
    end

    def self.from_env(kind)
      new kind,
          Bibliotheca::Env.atheneum_url,
          Bibliotheca::Env.atheneum_client_id,
          Bibliotheca::Env.atheneum_client_secret
    end

    def item_url(url)
      url += '/' unless url.end_with? '/'
      "#{url}api/#{kind.to_s.pluralize}"
    end

    def self.run!(kind, item)
      if env_available?
        from_env(kind).run!(item)
      else
        log_warning "Atheneum credentials not set. Not going to export #{item}."
      end
    end

    def run!(item)
      begin
        RestClient::Resource
          .new(self.item_url(url), client_id, client_secret)
          .post({slug: item.slug}, {content_type: 'json', accept: 'json'})
      rescue RestClient::Exception => e
        self.class.log_warning "Atheneum rejected item #{item.slug} update, reason: #{e.response}."
      rescue Exception => e
        self.class.log_warning "something went wrong while trying to update item #{item.slug}, error message is #{e.message}."
      end
    end

    private

    def self.env_available?
      Bibliotheca::Env.atheneum_url && Bibliotheca::Env.atheneum_client_id && Bibliotheca::Env.atheneum_client_secret
    end

    def self.log_warning(message)
      puts "Warning: #{message}"
    end
  end
end
