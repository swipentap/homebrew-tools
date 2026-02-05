# typed: false
# frozen_string_literal: true

class Enva < Formula
  desc "CLI for enva lab deployment (K3s, LXC, HAProxy, ArgoCD)"
  homepage "https://github.com/swipentap/enva"
  url "https://github.com/swipentap/enva/archive/refs/heads/main.tar.gz"
  sha256 "4d49aa123eaef5e8ff6fb079e39543f85114898239c78ddc92eee3cf6b0f5eed"
  version "0.0.1"
  head "https://github.com/swipentap/enva.git", branch: "main"

  depends_on "dotnet" => :build

  def install
    rid = Hardware::CPU.arm? ? "osx-arm64" : "osx-x64"
    system "dotnet", "publish", "src/Enva.csproj",
           "-c", "Release",
           "-r", rid,
           "--self-contained", "true",
           "-o", "publish"
    libexec.install Dir["publish/*"]
    (bin/"enva").write <<~EOS
      #!/bin/sh
      exec "#{libexec}/Enva" "$@"
    EOS
    chmod 0755, bin/"enva"
  end

  test do
    assert_match "enva", shell_output("#{bin}/enva --help", 0)
  end
end
