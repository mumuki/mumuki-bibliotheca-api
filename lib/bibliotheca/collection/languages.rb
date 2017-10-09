module Bibliotheca::Collection
  module Languages
    extend Mumukit::Service::Collection

    private

    def self.mongo_collection_name
      :languages
    end

    def self.mongo_database
      Bibliotheca::Database
    end

    def self.import!(url)
      import_from_json! Mumukit::Bridge::Runner.new(url).importable_info
    end

    def self.import_from_json!(language_json)
      upsert_by! :name, Bibliotheca::Language.new(language_json)

    end

    def self.wrap(it)
      Bibliotheca::Language.new(it)
    end

    def self.wrap_array(it)
      Bibliotheca::Collection::LanguageArray.new(it)
    end
  end

  class LanguageArray < Mumukit::Service::DocumentArray

    def options
      {except: [:id],
       full_language: true}
    end

    def key
      :languages
    end
  end
end


module Mumukit
  module Bridge
    class Runner
      def importable_info
        @language_json ||= info.merge('url' => test_runner_url)
        {
          name: @language_json['name'],
          comment_type: @language_json['comment_type'],
          extension: @language_json.dig('language', 'extension'),
          test_extension: @language_json.dig('test_framework', 'test_extension'),
          ace_mode: @language_json.dig('language', 'ace_mode'),
          devicon: @language_json.dig('language', 'icon', 'name'),
          test_runner_url: @language_json['url'],
          output_content_type: @language_json['output_content_type'],
          visible_success_output: @language_json.dig('language', 'graphic').present?,
          feedback: @language_json.dig('features', 'feedback'),
          highlight_mode: @language_json.dig('language', 'ace_mode'),
          prompt: (@language_json.dig('language', 'prompt') || 'ム') + ' ',
          queriable: @language_json.dig('features', 'query')
        }
      end
    end
  end
end

