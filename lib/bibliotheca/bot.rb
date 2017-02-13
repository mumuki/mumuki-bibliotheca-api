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

  def ensure_exists!(slug)
    create!(slug) unless exists?(slug)
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

  def register_post_commit_hook!(slug)
    octokit.create_hook(
        slug.to_s, 'web',
        {url: slug.bibliotheca_guide_web_hook_url, content_type: 'json'},
        {events: ['push'],
         active: true})
  rescue => e
    puts "not registering post commit hook: #{e.message}"
  end

  def authenticated?
    !!token
  end

  def self.from_env
    new Mumukit::Service::Env.bot_username,
        Mumukit::Service::Env.bot_email,
        Mumukit::Service::Env.bot_api_token
  end

  private

  def exists?(slug)
    Git.ls_remote(writable_github_url_for(slug))
    true
  rescue Git::GitExecuteError
    false
  end

  def create!(slug)
    octokit.create_repository(slug.repository, organization: slug.organization)
  end

  def writable_github_url_for(slug)
    "https://#{token}:@github.com/#{slug}"
  end

  def octokit
    Octokit::Client.new(access_token: token)
  end

  def private_repo_error(message)
    ['could not read Username', 'Invalid username or password'].any? { |it| message.include? it }
  end
end
