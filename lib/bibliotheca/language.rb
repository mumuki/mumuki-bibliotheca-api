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
      response[:expectation_results] = [] if response[:status] == :errored
      response[:expectation_results].map! { |it| {result: it[:result], title: Mumukit::Inspection::I18n.t(it)} }
      if response[:test_results].present?
        response.merge!(visible_success_output: visible_success_output,
                        test_results: response[:test_results].map { |it| test_results it },
                        output_content_type: output_html_content_type(response[:result]))
      else
        response[:result] = output_html_content_type(response[:result])
        response[:feedback] = feedback ? output_html_content_type(response[:feedback]) : ''
      end
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
