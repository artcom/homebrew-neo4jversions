require 'formula'

class Neo4j2m03 < Formula
  homepage 'http://neo4j.org'
  url 'http://dist.neo4j.org/neo4j-community-2.0.0-M03-unix.tar.gz'
  sha1 'be4695ba51579c68ccdfb3b0ec3ccaec0f51b26e'
  version '2.0.0-M03'

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]

    # Fix the permissions on the global settings file.
    chmod 0644, Dir["config"]

    # Install jars in libexec to avoid conflicts
    libexec.install Dir['*']

    # Symlink binaries
    bin.install_symlink "#{libexec}/bin/neo4j" => "neo4j-2m03"
    bin.install_symlink "#{libexec}/bin/neo4j-shell" => "neo4j-2m03-shell"

    # Adjust UDC props
    open("#{libexec}/conf/neo4j-wrapper.conf", 'a') { |f|
      f.puts "wrapper.java.additional.4=-Dneo4j.ext.udc.source=homebrew"

      # suppress the empty, focus-stealing java gui
      f.puts "wrapper.java.additional=-Djava.awt.headless=true"
    }
  end

  def caveats; <<-EOS.undent
    Quick-start guide:

        1. Start the server manually:
            neo4j-2m03 start

        2. Open webadmin:
            open http://localhost:7474/webadmin/

        3. Start exploring the REST API:
            curl -v http://localhost:7474/db/data/

        4. Stop:
            neo4j-2m03 stop

    To launch on startup, install launchd-agent to ~/Library/LaunchAgents/ with:
        neo4j install

    If this is an upgrade, see:
        #{libexec}/UPGRADE.txt

    The manual can be found in:
        #{libexec}/doc/

    You may need to add JAVA_HOME to your shell profile:
        export JAVA_HOME="$(/usr/libexec/java_home)"

    EOS
  end
end
