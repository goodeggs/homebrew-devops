class Migrate < Formula
  desc "Database migrations. CLI and Golang library."
  homepage "https://github.com/mattes/migrate"
  version "3.0.1"
  url "https://github.com/mattes/migrate/releases/download/v#{version}/migrate.darwin-amd64.tar.gz"
  sha256 "17e19678e930d4a48114937fb07300c107088d86a80c798630fabc08d32ee4ee"

  def install
    bin.install "migrate.darwin-amd64" => "migrate"
  end

  test do
    output = shell_output(bin/"migrate --version")
    assert_match version, output
  end
end
