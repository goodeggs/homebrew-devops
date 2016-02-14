class Ranch < Formula
  desc "Ranch Platform CLI"
  homepage "https://github.com/goodeggs/platform/tree/master/cmd/ranch"
  url "https://github.com/goodeggs/platform/archive/v1.0.2.tar.gz"
  sha256 "1bb3db5f4cd8a8bff2639ce58dfdface37ba1eec21c2f17f3163533634a7bdd8"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    path = buildpath/"src/github.com/goodeggs/platform"
    path.install Dir["*"]

    cd path/"cmd/ranch" do
      system "go", "build"
      bin.install "ranch"
    end
  end

  test do
    output = shell_output(bin/"ranch version")
    assert_match version.to_s, output
  end
end
