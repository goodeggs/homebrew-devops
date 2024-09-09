class ChromedriverService < Formula
  desc "Adds a service for Chromedriver"
  homepage "https://sites.google.com/a/chromium.org/chromedriver/"
  url "https://raw.githubusercontent.com/goodeggs/homebrew-devops/master/.empty.tgz" # fake it
  sha256 "863b571777ca92b569c1b61491fc0fe5f3e5e6b0ce77655e2ab10e639c3764e2"
  version "1.0"

  #depends_on :chromedriver

  def install
    prefix.install 'empty'
  end

  service do
    run ["/usr/local/bin/chromedriver"]
    keep_alive false
    working_dir HOMEBREW_PREFIX
    log_path var/"log/chromedriver-output.log"
    error_log_path var/"log/chromedriver-error.log"
  end
end