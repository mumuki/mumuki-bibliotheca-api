module Bibliotheca::IO
  class AtheneumExport
    attr_accessor :slug

    def initialize(options)
      @slug = options[:slug]
    end

    def item_url
      "#{url}api/#{kind.to_s.pluralize}"
    end

    def run!
      if env_available?
        RestClient::Resource
        .new(self.item_url, client_id, client_secret)
        .post({slug: slug}, {content_type: 'json', accept: 'json'})
      else
        log_warning "Atheneum credentials not set. Not going to export #{slug}."
      end
    rescue RestClient::Exception => e
      log_warning "Atheneum rejected item #{slug} update, reason: #{e.response}."
    rescue Exception => e
      log_warning "something went wrong while trying to update item #{slug}, error message is #{e.message}."
    end

    private

    def url
      Bibliotheca::Env.atheneum_url.try do |url|
        !url.end_with?('/') ? "#{url}/" : url
      end
    end

    def client_id
      Bibliotheca::Env.atheneum_client_id
    end

    def client_secret
      Bibliotheca::Env.atheneum_client_secret
    end

    def env_available?
      url && client_id && client_secret
    end

    def log_warning(message)
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
