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
      render_test_results response
      response
    end


    def render_test_results(response)
      if has_test_results?(response)
        with_full_test_results!(response)
      else
        with_full_result!(response)
      end
      with_full_expectations!(response)
      with_feedback!(response)
    end

    def with_full_result!(response)
      response[:result] = output_html_content_type(response[:result])
    end

    def with_full_test_results!(response)
      response.merge!(visible_success_output: visible_success_output,
                      test_results: response[:test_results].map { |it| test_results it },
                      output_content_type: output_html_content_type(response[:result]))
    end

    def has_test_results?(response)
      response[:test_results].present?
    end

    def with_feedback!(response)
      response[:feedback] = feedback ? output_html_content_type(response[:feedback]) : ''
    end

    def with_full_expectations!(response)
      response[:expectation_results] = [] if response[:status] == :errored
      response[:expectation_results].map! { |it| {result: it[:result], title: Mumukit::Inspection::I18n.t(it)} }
    end

    def output_html_content_type(content)
      Mumukit::ContentType.for(json[:output_content_type]).to_html(content)
    end

    def test_results(test)
      test[:result] = output_html_content_type test[:result]
      test
    end
  end
end
