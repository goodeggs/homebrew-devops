require 'formula'

class GitCryptKeeper < Formula
  homepage 'https://github.com/goodeggs/homebrew-devops/'
  url 'https://github.com/goodeggs/homebrew-devops.git'
  version '2.6.1' # keep in sync with https://github.com/goodeggs/platform-docker-base

  depends_on "docker"

  def install
    id = `docker create goodeggs/platform-base:#{version} false`.strip
    $? == 0 or raise "docker create failed with #{$?}"
    system "docker cp '#{id}:/usr/local/bin/git-crypt-keeper' ."
    system "docker rm '#{id}'"
    bin.install 'git-crypt-keeper'
  end

  def test
    system "$(brew --prefix git-crypt-keeper)/git-crypt-keeper help"
  end
end
