module Mumuki
  module Bibliotheca
    API_SYNC_INFLATORS = [Mumukit::Sync::Inflator::SingleChoice.new, Mumukit::Sync::Inflator::MultipleChoice.new]
    HISTORY_SYNC_INFLATORS = []

    def self.history_syncer(username = nil)
      Mumukit::Sync::Syncer.new(
        ## FIXME remove this hardcoded URL. Get it from Mumukit::Platform.application
        Mumukit::Sync::Store::Github.new(
            Mumukit::Sync::Store::Github::Bot.from_env,
            username,
            "http://bibliotheca-api.mumuki.io/guides/import/"),
        HISTORY_SYNC_INFLATORS)
    end

    def self.api_syncer(json)
      Mumukit::Sync::Syncer.new(ApiSource.new(json), API_SYNC_INFLATORS)
    end

    class ApiSource < Mumukit::Sync::Store::Json
      include Mumukit::Sync::Store::WithWrappedLanguage
    end
  end
end
