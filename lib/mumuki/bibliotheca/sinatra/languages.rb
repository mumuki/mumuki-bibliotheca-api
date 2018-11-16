get '/languages' do
  { languages: Language.all.as_json(only: fields).map { |it| transform(it) } }
end

def transform(language)
  language[:test_runner_url] = language.delete 'runner_url'
  language[:ace_mode] = language['highlight_mode']
  language[:feedback] = false
  language[:test_template] = ''
  language
end

def fields
  %i(
  comment_type
  devicon
  editor_css_urls
  editor_html_urls
  editor_js_urls
  extension
  highlight_mode
  layout_css_urls
  layout_html_urls
  layout_js_urls
  name
  output_content_type
  prompt
  queriable
  stateful_console
  test_extension
  runner_url
  triable
  visible_success_output
  )
end
