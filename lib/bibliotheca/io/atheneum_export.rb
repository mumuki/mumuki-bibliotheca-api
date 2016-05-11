module Bibliotheca::IO
  class AtheneumExport
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

    def item_url(url)
      url += '/' unless url.end_with? '/'
      "#{url}api/#{kind.to_s.pluralize}"
    end

    def self.run!(slug)
      if env_available?
        from_env.run!(slug)
      else
        log_warning "Atheneum credentials not set. Not going to export #{slug}."
      end
    end

    def run!(slug)
      begin
        RestClient::Resource
          .new(self.item_url(url), client_id, client_secret)
          .post({slug: slug}, {content_type: 'json', accept: 'json'})
      rescue RestClient::Exception => e
        self.class.log_warning "Atheneum rejected item #{slug} update, reason: #{e.response}."
      rescue Exception => e
        self.class.log_warning "something went wrong while trying to update item #{slug}, error message is #{e.message}."
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

  class GuideAtheneumExport < AtheneumExport
    def kind
      :guide
    end
  end

  class TopicAtheneumExport < AtheneumExport
    def kind
      :topic
    end
  end

  class BookAtheneumExport < AtheneumExport
    def kind
      :book
    end
  end
end
