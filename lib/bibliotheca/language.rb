module Bibliotheca
  class Language < Mumukit::Service::Document

    def as_json(options={})
      if options[:full_language]
        super
      else
        name
      end
    end

    def run_tests!(request)
      response = Mumukit::Bridge::Runner.new(test_runner_url).run_tests! request
      response.ui(self)
    end
  end
end


module Mumukit
  module Bridge
    class Runner
      alias __run_tests__! run_tests!

      def run_tests!(request)
        response = __run_tests__! request
        Mumukit::RunTest::Response.new response
      end
    end
  end
end


module Mumukit
  module RunTest
    class Response

      attr_reader :response

      def initialize(response)
        @response = response.to_h.with_indifferent_access
      end

      def as_json(options)
        response.as_json(options)
      end

      def raw(language)
        Mumukit::RunTest::Response::Raw.for(response, language)
      end

      def ui(language)
        Mumukit::RunTest::Response::UI.for(response, language)
      end


      class Raw
        def self.for(response, _)
          response
        end
      end


      class UI
        class << self
          def for(response, language)
            response_dup = response.dup
            if response_dup[:test_results].present?
              prettify_test_results! response_dup, language
            else
              prettify_result! response_dup, language
            end
            prettify_expectation_results! response_dup
            prettify_feedback! response_dup, language
            response_dup
          end

          def prettify_result!(response, language)
            response[:result] = output_html(response[:result], language)
          end

          def prettify_test_results!(response, language)
            response.merge!(visible_success_output: language.visible_success_output,
                            test_results: response[:test_results].map { |it| prettify_test_result! it, language },
                            output_content_type: output_html(response[:result], language))
          end

          def prettify_feedback!(response, language)
            response[:feedback] = output_html(response[:feedback], language) if language.feedback.present? && response[:feedback].present?
          end

          def prettify_expectation_results!(response)
            puts response
            response[:expectation_results] ||= []
            response[:expectation_results].map! { |it| prettify_expectation_result! it }
          end

          def output_html(content, language)
            Mumukit::ContentType.for(language.json[:output_content_type]).to_html(content)
          end

          def prettify_expectation_result!(expectation)
            expectation.merge title: Mumukit::Inspection::I18n.t(expectation)
          end

          def prettify_test_result!(test_result, language)
            test_result[:result] = output_html test_result[:result], language
            test_result
          end
        end
      end
    end
  end
end
