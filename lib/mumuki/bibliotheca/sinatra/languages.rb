get '/languages' do
  { languages: Language.all.as_json(only: [:extension, :name, :test_extension]) }
end
