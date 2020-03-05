require 'formula'

class GitCryptKeeper < Formula
  homepage 'https://github.com/goodeggs/homebrew-devops/'
  url 'https://github.com/goodeggs/homebrew-devops.git'
  version '1.0.2'

  def install
    bin.install 'git-crypt-keeper'
  end

  def test
    system "$(brew --prefix git-crypt-keeper)/git-crypt-keeper help"
  end
end
