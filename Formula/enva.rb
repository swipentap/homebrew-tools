# typed: false
# frozen_string_literal: true

class Enva < Formula
  desc "CLI for enva lab deployment (K3s, LXC, HAProxy, ArgoCD)"
  homepage "https://github.com/swipentap/enva"
  version "0.0.24"

  on_macos do
    on_arm do
      url "https://github.com/swipentap/enva/releases/download/v#{version}/enva-#{version}-darwin-arm64.tar.gz"
      sha256 "6884172a83d5cafd856241912efe4aa9b4d8d62a2e64b21c7b66cf9f77863157"
    end
    on_intel do
      url "https://github.com/swipentap/enva/releases/download/v#{version}/enva-#{version}-darwin-amd64.tar.gz"
      sha256 "79fe15e60fd70aa186e9ceca34984f85032d966db5642f89d36d0e2e88a7d550"
    end
  end
  on_linux do
    on_arm do
      url "https://github.com/swipentap/enva/releases/download/v#{version}/enva-#{version}-linux-arm64.tar.gz"
      sha256 "8ac69d70f9ea25602989ee4f997e0267a7b8af111be7cc32c264eadf1f82f5b3"
    end
    on_intel do
      url "https://github.com/swipentap/enva/releases/download/v#{version}/enva-#{version}-linux-amd64.tar.gz"
      sha256 "3146e4dd4be64623ab6e5f3ea529381bc64ffa206fe66a1f8ebae8f8c2c81e58"
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
