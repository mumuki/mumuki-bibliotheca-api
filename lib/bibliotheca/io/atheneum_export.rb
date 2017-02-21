module Bibliotheca::IO
  class AtheneumExport
    attr_accessor :slug

    def initialize(options)
      @slug = options[:slug]
    end

    def run!
      Mumukit::Nuntius.notify_event! event, slug: slug
    end
  end

  class GuideAtheneumExport < AtheneumExport
    def event
      :GuideChanged
    end
  end

  class TopicAtheneumExport < AtheneumExport
    def event
      :TopicChanged
    end
  end

  class BookAtheneumExport < AtheneumExport
    def event
      :BookChanged
    end
  end
end
