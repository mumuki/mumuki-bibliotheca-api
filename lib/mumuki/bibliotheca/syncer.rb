module Mumuki
  module Bibliotheca
    class ApiSource < Mumukit::Sync::Store::Json
      include Mumukit::Sync::Store::WithWrappedLanguage
    end

    class << self
      class_attribute :api_inflators, :history_inflators, :history_store, :assets_uploader

      self.api_inflators = [Mumukit::Sync::Inflator::SingleChoice.new, Mumukit::Sync::Inflator::MultipleChoice.new]
      self.history_inflators = []
      self.history_store = proc { |_user| Mumukit::Sync::Store::NullStore.new }
      self.assets_uploader = proc { |_slug, _name, _content| raise 'Can not upload file' }

      def upload_asset!(slug, name, content)
        assets_uploader[slug, name, content]
      end

      def history_syncer(user)
        Mumukit::Sync::Syncer.new(history_store[user], history_inflators)
      end

      def api_syncer(json)
        Mumukit::Sync::Syncer.new(ApiSource.new(json), api_inflators)
      end
    end
  end
end
