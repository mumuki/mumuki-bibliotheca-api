namespace :guides do
  task :import, [:organization, :url] do |t, args|
    args.with_defaults(url: 'http://localhost:9292')

    org = args[:organization]
    url = args[:url]

    puts "importing guides from organization #{org} into #{url}"

    Octokit.repos(org).map(&:full_name).select { |it| it =~ /guia/ }.each do |slug|
      puts "importing guide #{slug}...."
      begin
        RestClient.post "#{url}/guides/import/#{slug}", {}
      rescue => e
        puts "import failed! #{e.response}"
      end
    end
  end
end





