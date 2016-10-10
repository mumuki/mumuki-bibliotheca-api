namespace :guides do
  def guides_for_organization(org)
    Octokit.repos(org).map(&:full_name).select { |it| it =~ /guia/ }
  end

  task :import, [:organization, :url] do |t, args|
    args.with_defaults(url: 'http://localhost:9292')

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


  task :waffle, [:organization, :board_id, :access_token] do
    org = args[:organization]
    board_id = args[:board_id]
    access_token = args[:access_token]

    data = {private: false, repoPath: slug, type: 'github', provider: board_id}
    guides_for_organization(org).each do |slug|
      puts "adding guide repo #{slug} to waffle board #{board_id}"
      begin
        RestClient.post "https://api.waffle.io/projects/#{board_id}/sources", data, {:Authorization => "Bearer #{access_token}"}
        puts 'Added!'
      rescue => e
        puts "adding repo to waffle failed! #{e.response}"
      end
    end
  end
end





