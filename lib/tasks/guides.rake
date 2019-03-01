namespace :bibliotheca do
  namespace :guides do
    def guides_for_organization(org)
      Octokit.auto_paginate = true
      Octokit.repos(org).map(&:full_name).select { |it| it =~ /guia/ }
    end

    task :export, [:author_email] do |_t, args|
      author_email = args[:author_email]
      Bibliotheca::Collection::Guides.all.each do |it|
        it.export! author_email rescue (puts "ignoring #{it.slug}")
      end
    end

    task :import_from_github, [:organization, :url] do |_t, args|
      args.with_defaults(url: 'http://localhost:3004')

      org = args[:organization]
      url = args[:url]

      puts "importing guides from organization #{org} into #{url}"

      guides_for_organization(org).each do |slug|
        puts "importing guide #{slug}...."
        begin
          RestClient.post "#{url}/guides/import/#{slug}", {}
        rescue => e
          puts "import failed! #{e.response}"
        end
      end
    end
  end
end
