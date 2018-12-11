class BibliothecaApi < Sinatra::Application
  get '/languages' do
    { languages: Language.all.map { |it| transform(it) } }
  end

  def transform(language)
    language
      .to_resource_h
      .replace_key!(:runner_url, :test_runner_url)
  end
end
