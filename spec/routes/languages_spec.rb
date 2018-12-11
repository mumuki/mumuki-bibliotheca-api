require 'spec_helper'

describe 'routes' do
  def app
    BibliothecaApi.new
  end

  describe('get /languages') do
    let!(:haskell) do
      create(:language,
        name: "gobstones",
        comment_type: nil,
        runner_url: "http://foo",
        output_content_type: "html",
        prompt: "ム ",
        extension: "gbs",
        highlight_mode: "gobstones",
        visible_success_output: true,
        devicon: 'gobstones',
        triable: false,
        feedback: true,
        queriable: false,
        stateful_console: false,
        test_extension: "yml",
        test_template: 'template',
        layout_js_urls: ['http://runner.com/javascripts/a.js'],
        layout_html_urls: ["http://runner.com/b.html", "http://runner.com/c.html"],
        layout_css_urls: ["http://runner.com/stylesheets/d.css"],
        editor_js_urls: ['http://runner.com/javascripts/aa.js'],
        editor_html_urls: ["http://runner.com/bb.html", "http://runner.com/cc.html"],
        editor_css_urls: ["http://runner.com/stylesheets/dd.css"])
    end

    before do
      get '/languages'
    end

    it { expect(last_response.body).to json_eq languages: [{
                                                  name: "gobstones",
                                                  comment_type: nil,
                                                  test_runner_url: "http://foo",
                                                  output_content_type: "html",
                                                  prompt: "ム ",
                                                  extension: "gbs",
                                                  highlight_mode: "gobstones",
                                                  visible_success_output: true,
                                                  devicon: 'gobstones',
                                                  triable: false,
                                                  feedback: true,
                                                  queriable: false,
                                                  stateful_console: false,
                                                  test_extension: "yml",
                                                  test_template: 'template',
                                                  layout_js_urls: ['http://runner.com/javascripts/a.js'],
                                                  layout_html_urls: ["http://runner.com/b.html", "http://runner.com/c.html"],
                                                  layout_css_urls: ["http://runner.com/stylesheets/d.css"],
                                                  editor_js_urls: ['http://runner.com/javascripts/aa.js'],
                                                  editor_html_urls: ["http://runner.com/bb.html", "http://runner.com/cc.html"],
                                                  editor_css_urls: ["http://runner.com/stylesheets/dd.css"] }] }
  end
end
