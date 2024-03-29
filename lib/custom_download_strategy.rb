# from https://raw.githubusercontent.com/dollarshaveclub/homebrew-public/master/custom_download_strategy.rb

require "download_strategy"

# GitHubPrivateRepositoryDownloadStrategy downloads contents from GitHub
# Private Repository. To use it, add
# `:using => CustomGitHubPrivateRepositoryDownloadStrategy` to the URL section of
# your formula. This download strategy uses GitHub access tokens (in the
# environment variables `HOMEBREW_GITHUB_API_TOKEN`) to sign the request.  This
# strategy is suitable for corporate use just like S3DownloadStrategy, because
# it lets you use a private GitHub repository for internal distribution.  It
# works with public one, but in that case simply use CurlDownloadStrategy.
class CustomGitHubPrivateRepositoryDownloadStrategy < CurlDownloadStrategy
  require "utils/formatter"
  require "utils/github"

  def initialize(url, name, version, **meta)
    super
    parse_url_pattern
    set_github_token
  end

  def parse_url_pattern
    unless match = url.match(%r{https://github.com/([^/]+)/([^/]+)/(\S+)})
      raise CurlDownloadStrategyError, "Invalid url pattern for GitHub Repository."
    end

    _, @owner, @repo, @filepath = *match
  end

  def download_url
    "https://github.com/#{@owner}/#{@repo}/#{@filepath}"
  end

  private

  def _fetch(url:, resolved_url:, timeout: nil)
    curl_download download_url, "--header", "Authorization: token #{@github_token}", to: temporary_path
  end

  def set_github_token
    @github_token = ENV["HOMEBREW_GITHUB_API_TOKEN"]
    unless @github_token
      raise CurlDownloadStrategyError, "Environmental variable HOMEBREW_GITHUB_API_TOKEN is required."
    end

    validate_github_repository_access!
  end

  def validate_github_repository_access!
    # Test access to the repository
    GitHub.repository(@owner, @repo)
  rescue GitHub::HTTPNotFoundError
    # We only handle HTTPNotFoundError here,
    # becase AuthenticationFailedError is handled within util/github.
    message = <<~EOS
      HOMEBREW_GITHUB_API_TOKEN can not access the repository: #{@owner}/#{@repo}
      This token may not have permission to access the repository or the url of formula may be incorrect.
    EOS
    raise CurlDownloadStrategyError, message
  end
end

# GitHubPrivateRepositoryReleaseDownloadStrategy downloads tarballs from GitHub
# Release assets. To use it, add `:using => CustomGitHubPrivateRepositoryReleaseDownloadStrategy` to the URL section
# of your formula. This download strategy uses GitHub access tokens (in the
# environment variables HOMEBREW_GITHUB_API_TOKEN) to sign the request.
class CustomGitHubPrivateRepositoryReleaseDownloadStrategy < CustomGitHubPrivateRepositoryDownloadStrategy
  require 'net/http'

  def initialize(url, name, version, **meta)
    super
  end

  def parse_url_pattern
    url_pattern = %r{https://github.com/([^/]+)/([^/]+)/releases/download/([^/]+)/(\S+)}
    unless @url =~ url_pattern
      raise CurlDownloadStrategyError, "Invalid url pattern for GitHub Release."
    end

    _, @owner, @repo, @tag, @filename = *@url.match(url_pattern)
  end

  def download_url
    #"https://#{@github_token}@api.github.com/repos/#{@owner}/#{@repo}/releases/assets/#{asset_id}"
    #blah = curl_output "--header", "Accept: application/octet-stream", "--header", "Authorization: token #{@github_token}", "-I"
    uri = URI("https://api.github.com/repos/#{@owner}/#{@repo}/releases/assets/#{asset_id}")
    req = Net::HTTP::Get.new(uri)
    req['Accept'] = 'application/octet-stream'
    req['Authorization'] = "token #{@github_token}"

    res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      http.request(req)
    end

    res['location']
  end

  private

  def _fetch(url:, resolved_url:, timeout: nil)
    # HTTP request header `Accept: application/octet-stream` is required.
    # Without this, the GitHub API will respond with metadata, not binary.
    curl_download download_url, "--header", "Accept: application/octet-stream", to: temporary_path
  end

  def asset_id
    @asset_id ||= resolve_asset_id
  end

  def resolve_asset_id
    release_metadata = fetch_release_metadata
    assets = release_metadata["assets"].select { |a| a["name"] == @filename }
    raise CurlDownloadStrategyError, "Asset file not found." if assets.empty?

    assets.first["id"]
  end

  def fetch_release_metadata
    release_url = "https://api.github.com/repos/#{@owner}/#{@repo}/releases/tags/#{@tag}"
    GitHub::API.open_rest(release_url)
  end
end

# ScpDownloadStrategy downloads files using ssh via scp. To use it, add
# `:using => ScpDownloadStrategy` to the URL section of your formula or
# provide a URL starting with scp://. This strategy uses ssh credentials for
# authentication. If a public/private keypair is configured, it will not
# prompt for a password.
#
# @example
#   class Abc < Formula
#     url "scp://example.com/src/abc.1.0.tar.gz"
#     ...
class ScpDownloadStrategy < AbstractFileDownloadStrategy
  def initialize(url, name, version, **meta)
    odisabled("ScpDownloadStrategy",
      "a vendored ScpDownloadStrategy in your own formula or tap (using require_relative)")
    super
    parse_url_pattern
  end

  def parse_url_pattern
    url_pattern = %r{scp://([^@]+@)?([^@:/]+)(:\d+)?/(\S+)}
    if @url !~ url_pattern
      raise ScpDownloadStrategyError, "Invalid URL for scp: #{@url}"
    end

    _, @user, @host, @port, @path = *@url.match(url_pattern)
  end

  def fetch
    ohai "Downloading #{@url}"

    if cached_location.exist?
      puts "Already downloaded: #{cached_location}"
    else
      system_command! "scp", args: [scp_source, temporary_path.to_s]
      ignore_interrupts { temporary_path.rename(cached_location) }
    end
  end

  def clear_cache
    super
    rm_rf(temporary_path)
  end

  private

  def scp_source
    path_prefix = "/" unless @path.start_with?("~")
    port_arg = "-P #{@port[1..-1]} " if @port
    "#{port_arg}#{@user}#{@host}:#{path_prefix}#{@path}"
  end
end

class DownloadStrategyDetector
  class << self
    module Compat
      def detect_from_url(url)
        case url
        when %r{^s3://}
          odisabled("s3://",
            "a vendored S3DownloadStrategy in your own formula or tap (using require_relative)")
          S3DownloadStrategy
        when %r{^scp://}
          odisabled("scp://",
            "a vendored ScpDownloadStrategy in your own formula or tap (using require_relative)")
          ScpDownloadStrategy
        else
          super(url)
        end
      end

      def detect_from_symbol(symbol)
        case symbol
        when :github_private_repo
          odisabled(":github_private_repo",
            "a vendored GitHubPrivateRepositoryDownloadStrategy in your own formula or tap (using require_relative)")
          GitHubPrivateRepositoryDownloadStrategy
        when :github_private_release
          odisabled(":github_private_repo",
            "a vendored GitHubPrivateRepositoryReleaseDownloadStrategy in your own formula or tap "\
            "(using require_relative)")
          GitHubPrivateRepositoryReleaseDownloadStrategy
        when :s3
          odisabled(":s3",
            "a vendored S3DownloadStrategy in your own formula or tap (using require_relative)")
          S3DownloadStrategy
        when :scp
          odisabled(":scp",
            "a vendored ScpDownloadStrategy in your own formula or tap (using require_relative)")
          ScpDownloadStrategy
        else
          super(symbol)
        end
      end
    end

    prepend Compat
  end
end
