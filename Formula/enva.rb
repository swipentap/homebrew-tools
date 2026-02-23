# typed: false
# frozen_string_literal: true

class Enva < Formula
  desc "CLI for enva lab deployment (K3s, LXC, HAProxy, ArgoCD)"
  homepage "https://github.com/swipentap/enva"
  version "0.0.14"

  on_macos do
    on_arm do
      url "https://github.com/swipentap/enva/releases/download/v#{version}/enva-#{version}-darwin-arm64.tar.gz"
      sha256 "644367b8cf30e409775e948f9bdf9191beddf3d32dcbe6295a8b3d4ea08f1861"
    end
    on_intel do
      url "https://github.com/swipentap/enva/releases/download/v#{version}/enva-#{version}-darwin-amd64.tar.gz"
      sha256 "c039d28fd5ee06f64dbb586a4d15530c069867333ea18b769b68fb2de936551b"
    end
  end
  on_linux do
    on_arm do
      url "https://github.com/swipentap/enva/releases/download/v#{version}/enva-#{version}-linux-arm64.tar.gz"
      sha256 "ea6e3289da16516d012292063575b8fb919a6d18d72013ba1d500e80925c0cd4"
    end
    on_intel do
      url "https://github.com/swipentap/enva/releases/download/v#{version}/enva-#{version}-linux-amd64.tar.gz"
      sha256 "83c205bdb890b386f8275452ced8531ad030d1e3a88fc5b0eefe11150290fe86"
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
