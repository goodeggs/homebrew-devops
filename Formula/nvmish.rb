require 'formula'

class Nvmish < Formula
  homepage 'https://github.com/goodeggs/homebrew-delivery-eng/'
  url 'https://github.com/goodeggs/homebrew-delivery-eng.git'
  version '2.0.0'

  depends_on 'jq'
  depends_on 'nvm'

  def install
    prefix.install 'nvmish.sh'
    prefix.install 'nvmish-zsh.sh'
    prefix.install 'nvmish-bash.sh'
  end

  def test
    system "/usr/bin/env bash -c 'source $(brew --prefix nvmish)/nvmish-bash.sh; type nvmish'"
    system "/usr/bin/env zsh -c 'source $(brew --prefix nvmish)/nvmish-zsh.sh; type nvmish'"
  end

  def caveats
    <<-EOS.undent
      You need to add these lines to your .zshrc:

          source $(brew --prefix nvmish)/nvmish-zsh.sh

      or these lines to your .bash_profile:

          source $(brew --prefix nvmish)/nvmish-bash.sh

    EOS
  end

end
