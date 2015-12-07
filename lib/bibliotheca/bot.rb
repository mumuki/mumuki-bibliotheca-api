require 'git'
require 'octokit'

class Bibliotheca::Bot
  attr_accessor :token, :name, :email

  def initialize(name, email, token)
    @name = name
    @email = email
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

  def register_post_commit_hook!(repo)
    octokit.create_hook(
        repo.full_name, 'web',
        {url: repo.web_hook_url, content_type: 'json'},
        {events: ['push'],
         active: true})
  end


  def self.from_env
    self.new 'mumukibot', 'bot@mumuki.org', ENV['MUMUKIBOT_GITHUB_TOKEN']
  end

  private

  def private_repo_error(message)
    ['could not read Username', 'Invalid username or password'].any? { |it| message.include? it }
  end
end
