require 'spec_helper'

describe 'routes' do
  def app
    Mumuki::Bibliotheca::App
  end

  describe('get /languages') do
    let!(:haskell) do
      create(:language,
             comment_type: 'cpp',
             devicon: 'gobstones',
             editor_css_urls: ['http://runner.com/stylesheets/dd.css'],
             editor_html_urls: ['http://runner.com/bb.html', 'http://runner.com/cc.html'],
             editor_js_urls: ['http://runner.com/javascripts/aa.js'],
             editor_shows_loading_content: false,
             extension: 'gbs',
             feedback: true,
             highlight_mode: 'gobstones',
             layout_css_urls: ['http://runner.com/stylesheets/d.css'],
             layout_html_urls: ['http://runner.com/b.html', 'http://runner.com/c.html'],
             layout_js_urls: ['http://runner.com/javascripts/a.js'],
             layout_shows_loading_content: false,
             multifile: false,
             name: 'gobstones',
             output_content_type: 'html',
             prompt: 'ム ',
             queriable: false,
             runner_url: 'http://foo',
             settings: false,
             stateful_console: false,
             test_extension: 'yml',
             test_template: 'template',
             triable: false,
             visible_success_output: true
      )
    end

    before do
      get '/languages'
    end

    it {
      expect(last_response.body).to json_eq languages: [
        {
          comment_type: 'cpp',
          devicon: 'gobstones',
          editor_css_urls: ['http://runner.com/stylesheets/dd.css'],
          editor_html_urls: ['http://runner.com/bb.html', 'http://runner.com/cc.html'],
          editor_js_urls: ['http://runner.com/javascripts/aa.js'],
          editor_shows_loading_content: false,
          extension: 'gbs',
          feedback: true,
          highlight_mode: 'gobstones',
          layout_css_urls: ['http://runner.com/stylesheets/d.css'],
          layout_html_urls: ['http://runner.com/b.html', 'http://runner.com/c.html'],
          layout_js_urls: ['http://runner.com/javascripts/a.js'],
          layout_shows_loading_content: false,
          multifile: false,
          name: 'gobstones',
          output_content_type: 'html',
          prompt: 'ム ',
          queriable: false,
          settings: false,
          stateful_console: false,
          test_extension: 'yml',
          test_runner_url: 'http://foo',
          test_template: 'template',
          triable: false,
          visible_success_output: true
        }
      ]
    }
  end
end
