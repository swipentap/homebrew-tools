# typed: false
# frozen_string_literal: true

class Enva < Formula
  desc "CLI for enva lab deployment (K3s, LXC, HAProxy, ArgoCD)"
  homepage "https://github.com/swipentap/enva"
  version "0.0.21"

  on_macos do
    on_arm do
      url "https://github.com/swipentap/enva/releases/download/v#{version}/enva-#{version}-darwin-arm64.tar.gz"
      sha256 "c80245178f17f56d40410b796d96cbc8a3628d4271b96f578f1b8512ca7954e3"
    end
    on_intel do
      url "https://github.com/swipentap/enva/releases/download/v#{version}/enva-#{version}-darwin-amd64.tar.gz"
      sha256 "9ac756f43d79107480e0612d771f0f9fd13065ed4572cf37a51b3fa6a47b093a"
    end
  end
  on_linux do
    on_arm do
      url "https://github.com/swipentap/enva/releases/download/v#{version}/enva-#{version}-linux-arm64.tar.gz"
      sha256 "474c99f12bbb02b7181148b5c7df361baa1ed546468a655924dd535513345dfd"
    end
    on_intel do
      url "https://github.com/swipentap/enva/releases/download/v#{version}/enva-#{version}-linux-amd64.tar.gz"
      sha256 "05bc644689a6c12765bcb4c056ee686316dedd6e4cff15e9b1d8eedc7e877f96"
    end
  end

  head "https://github.com/swipentap/enva.git", branch: "main"

  depends_on "dotnet" => :build if build.head?

  def install
    if build.head?
      rid = if OS.mac?
        Hardware::CPU.arm? ? "osx-arm64" : "osx-x64"
      else
        Hardware::CPU.arm? ? "linux-arm64" : "linux-x64"
      end
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
