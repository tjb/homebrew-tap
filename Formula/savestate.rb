class Savestate < Formula
  desc "Mac CLI and MCP server that lets coding agents drive iOS app debug state"
  homepage "https://github.com/tjb/SaveState"
  url "https://github.com/tjb/SaveState/archive/refs/tags/0.2.0.tar.gz"
  sha256 "f7c560b2cc9a06320e51dd24db8b7a38f0e4fa785ce12ce4df1d8db582278db0"
  license "MIT"

  depends_on xcode: ["26.0", :build]
  depends_on :macos

  on_macos do
    depends_on macos: :sequoia
  end

  def install
    cd "CLI" do
      system "swift", "build", "--disable-sandbox", "-c", "release", "--product", "savestate"
      bin.install ".build/release/savestate"
    end
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/savestate --version").strip

    initialize = '{"jsonrpc":"2.0","id":1,"method":"initialize","params":' \
                 '{"protocolVersion":"2025-03-26","capabilities":{},' \
                 '"clientInfo":{"name":"brew","version":"1"}}}'
    # Stdin stays open until the reply arrives, as it does with a real MCP client.
    reply = IO.popen([bin/"savestate", "mcp"], "r+") do |server|
      server.puts initialize
      server.flush
      server.gets
    end
    assert_match '"name":"savestate"', reply
  end
end
