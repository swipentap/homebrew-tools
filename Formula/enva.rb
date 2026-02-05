# typed: false
# frozen_string_literal: true

class Enva < Formula
  desc "CLI for enva lab deployment (K3s, LXC, HAProxy, ArgoCD)"
  homepage "https://github.com/swipentap/enva"
  version "0.0.6"

  on_arm do
    url "https://github.com/swipentap/enva/releases/download/v#{version}/enva-#{version}-darwin-arm64.tar.gz"
    sha256 "6330d6d2471876cf2317e19d42ed4cf6b39ddbc650882542da74b7a86a102487"
  end
  on_intel do
    url "https://github.com/swipentap/enva/releases/download/v#{version}/enva-#{version}-darwin-amd64.tar.gz"
    sha256 "f157132bb1a258910db7b5222a0c308dc602b704d68ef2e2de58ab9c0decfde5"
  end

  head "https://github.com/swipentap/enva.git", branch: "main"

  depends_on "dotnet" => :build if build.head?

  def install
    if build.head?
      rid = Hardware::CPU.arm? ? "osx-arm64" : "osx-x64"
      system "dotnet", "publish", "src/Enva.csproj",
             "-c", "Release", "-r", rid, "--self-contained", "true", "-o", "publish"
      libexec.install Dir["publish/*"]
      (bin/"enva").write <<~EOS
        #!/bin/sh
        exec "#{libexec}/Enva" "$@"
      EOS
      chmod 0755, bin/"enva"
    else
      bin.install "enva"
    end
  end

  test do
    assert_match "enva", shell_output("#{bin}/enva --help", 0)
  end
end
