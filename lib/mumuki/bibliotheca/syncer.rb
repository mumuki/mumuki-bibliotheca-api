module Mumuki
  module Bibliotheca
    class ApiSource < Mumukit::Sync::Store::Json
      include Mumukit::Sync::Store::WithWrappedLanguage
    end

    API_SYNC_INFLATORS = [Mumukit::Sync::Inflator::SingleChoice.new, Mumukit::Sync::Inflator::MultipleChoice.new]
    HISTORY_SYNC_INFLATORS = []
    HISTORY_SYNC_STORE = proc { |_user| Mumukit::Sync::Store::NullStore.new }
    ASSETS_UPLOADER = proc { |_slug, _name, _content| raise 'Can not upload file' }

    def self.upload_asset!(slug, name, content)
      ASSETS_UPLOADER[slug, name, content]
    end

    def self.history_syncer(user)
      Mumukit::Sync::Syncer.new(HISTORY_SYNC_STORE[user], HISTORY_SYNC_INFLATORS)
    end

    def self.api_syncer(json)
      Mumukit::Sync::Syncer.new(ApiSource.new(json), API_SYNC_INFLATORS)
    end
  end
end
