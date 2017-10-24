namespace :languages do
  task :import do |t, args|
    (%W(http://gobstones.runners.mumuki.io) + Mumukit::Bridge::Thesaurus.new(Mumukit::Platform.config.thesaurus_url).runners).each do |url|
      puts "Importing Language #{url}"
      begin
        Bibliotheca::Collection::Languages.import! url
      rescue => e
        puts "Ignoring Language #{url} because of import error #{e}"
      end
    end
  end
end
