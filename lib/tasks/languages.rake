namespace :languages do
  task :import do |t, args|
    Mumukit::Platform.thesaurus_bridge.import_languages! do |runner_url|
      Bibliotheca::Collection::Languages.import! runner_url
    end
  end
end
