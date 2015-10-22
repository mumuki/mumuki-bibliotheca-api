class GitIo::Bot
  attr_accessor :token, :name

  def initialize(name, token)
    @name = name
    @token = token
  end

  def octokit
    Octokit::Client.new(access_token: token)
  end

  def writable_github_url_for(repo)
    "https://#{token}:@github.com/#{repo.full_name}"
  end

  def contributors_for(repo)
    Rails.logger.info "Fetching contributors for repo #{repo}"
    bot.octokit.contribs(repo.full_name)
  end

  def collaborators_for(repo)
    Rails.logger.info "Fetching collaboratos for guide #{repo}"
    bot.octokit.collabs(repo.full_name)
  end

  def ensure_exists!(repo)
    create!(repo) unless exists?(repo)
  end

  def create!(repo)
    Rails.logger.info "Creating repository #{repo}"
    octokit.create_repository(repo.name, organization: repo.organization)
  end

  def exists?(repo)
    Git.ls_remote(writable_github_url_for(repo))
    true
  rescue Git::GitExecuteError
    false
  end

  def clone_into(repo, dir)
    g = Git.clone(writable_github_url_for(repo), '.', path: dir)
    g.config('user.name', name)
    g.config('user.email', email)
    g
  rescue Git::GitExecuteError => e
    raise 'Repository is private or does not exist' if private_repo_error(e.message)
    raise e
  end

  def can_commit_to?(repo)
    octokit.collaborator?(repo.full_name, name)
  rescue
    false
  end

  def register_post_commit_hook!(repo, web_hook)
    octokit.create_hook(
        repo.full_name, 'web',
        {url: web_hook, content_type: 'json'},
        {events: ['push'],
         active: true})
  end


  def self.from_env
    self.new 'mumukibot', ENV['MUMUKIBOT_GITHUB_TOKEN']
  end

  private

  def private_repo_error(message)
    ['could not read Username', 'Invalid username or password'].any? { |it| message.include? it }
  end
end
