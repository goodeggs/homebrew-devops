require 'formula'

class Nvmish < Formula
  homepage 'https://github.com/goodeggs/homebrew-delivery-eng/'
  url 'https://github.com/goodeggs/homebrew-delivery-eng.git'
  version '3.0.0'

  depends_on 'jq'
  depends_on 'nvm'

  def install
    prefix.install 'nvmish.sh'
    prefix.install Dir['vendor/bash_zsh_support']
  end

  def test
    system "/usr/bin/env bash -c 'source $(brew --prefix nvmish)/nvmish.sh; type nvmish'"
    system "/usr/bin/env zsh -c 'source $(brew --prefix nvmish)/nvmish.sh; type nvmish'"
  end

  def caveats
    <<-EOS.undent
      You need to add these lines to your .zshrc / .bash_profile / etc:

          source $(brew --prefix nvmish)/nvmish.sh

    EOS
  end

end
