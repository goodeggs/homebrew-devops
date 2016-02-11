class Ranch < Formula
  desc "Ranch Platform CLI"
  homepage "https://github.com/goodeggs/platform/tree/master/cmd/ranch"
  url "https://github.com/goodeggs/platform/archive/v1.0.0.tar.gz"
  sha256 "dfd69f46e2b5e1e6d6fba930cc69d91d7f434393df4fec02e3da12dd89d5dd4c"

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
