require 'git'
require 'octokit'

class Bibliotheca::Bot
  attr_accessor :token, :name, :email

  def initialize(name, email, token)
    ensure_present! name, email
    @name = name
    @email = email
    @token = token
  end

  def ensure_exists!(repo)
    create!(repo) unless exists?(repo)
  end

  def clone_into(repo, dir, &block)
    local_repo = Git.clone(writable_github_url_for(repo), '.', path: dir)
    local_repo.config('user.name', name)
    local_repo.config('user.email', email)
    yield dir, local_repo
  rescue Git::GitExecuteError => e
    raise 'Repository is private or does not exist' if private_repo_error(e.message)
    raise e
  end

  def register_post_commit_hook!(repo)
    octokit.create_hook(
        repo.full_name, 'web',
        {url: repo.web_hook_url, content_type: 'json'},
        {events: ['push'],
         active: true})
  rescue => e
    puts "not registering post commit hook: #{e.message}"
  end

  def authenticated?
    !!token
  end

  def self.from_env
    new Bibliotheca::Env.bot_username,
        Bibliotheca::Env.bot_email,
        Bibliotheca::Env.bot_api_token
  end

  private

  def exists?(repo)
    Git.ls_remote(writable_github_url_for(repo))
    true
  rescue Git::GitExecuteError
    false
  end

  def create!(repo)
    octokit.create_repository(repo.name, organization: repo.organization)
  end

  def writable_github_url_for(repo)
    "https://#{token}:@github.com/#{repo.full_name}"
  end

  def octokit
    Octokit::Client.new(access_token: token)
  end

  def private_repo_error(message)
    ['could not read Username', 'Invalid username or password'].any? { |it| message.include? it }
  end
end
