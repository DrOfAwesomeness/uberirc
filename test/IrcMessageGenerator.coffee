should = require("chai").should()
IrcMessageGenerator = require("../lib/IrcMessageGenerator.coffee")
describe "IrcMessageGenerator", ->
  # Section 3.1 - Connection Registration
  describe "#pass", ->
    it "should generate a valid PASS message", ->
      IrcMessageGenerator.pass("testpassword").should.equal "PASS testpassword"
  describe "#nick", ->
    it "should generate a valid NICK message", ->
      IrcMessageGenerator.nick("test").should.equal "NICK test"
  describe "#user", ->
    it "should generate a valid USER message", ->
      IrcMessageGenerator.user("testuser", "0", "Test User").should.equal "USER testuser 0 * :Test User"
  describe "#usermode", ->
    it "should generate a valid MODE message if a mode is specified", ->
      IrcMessageGenerator.usermode("test", "+i").should.equal "MODE test +i"
    it "should generate a valid MODE message if a mode is not specified", ->
      IrcMessageGenerator.usermode("test").should.equal "MODE test"
  describe "#service", ->
    it "should generate a valid SERVICE message", ->
      IrcMessageGenerator.service("example", "example", "*", "Example Service").should.equal "SERVICE example * example * * :Example Service"
  describe "#quit", ->
    it "should generate a valid QUIT message", ->
      IrcMessageGenerator.quit("Quit Reason").should.equal "QUIT :Quit Reason"
  describe "#squit", ->
    it "should generate a valid SQUIT message", ->
      IrcMessageGenerator.squit("badserver", "Bad Link").should.equal "SQUIT badserver :Bad Link"

  # Section 3.2 - Channel operations
  describe "#join", ->
    it "should generate a valid JOIN message if a key is specified", ->
      IrcMessageGenerator.join("#channel", "secret").should.equal "JOIN #channel secret"
    it "should generate a valid JOIN message if a key is not specified", ->
      IrcMessageGenerator.join("#channel").should.equal "JOIN #channel"
  describe "#part", ->
    it "should generate a valid PART message if a reason is specified", ->
      IrcMessageGenerator.part("#channel", "Some Reason").should.equal "PART #channel :Some Reason"
    it "should generate a valid PART message if a reason is not specified", ->
      IrcMessageGenerator.part("#channel").should.equal "PART #channel"
  describe "#channelmode", ->
    it "should generate a valid MODE message if a mode is specified", ->
      IrcMessageGenerator.channelmode("#channel", "+o", "test").should.equal "MODE #channel +o test"
    it "should generate a valid MODE message if a mode is not specified", ->
      IrcMessageGenerator.channelmode("#channel").should.equal "MODE #channel"
  describe "#topic", ->
    it "should generate a valid TOPIC message if a topic is specified", ->
      IrcMessageGenerator.topic("#channel", "Test Topic").should.equal "TOPIC #channel :Test Topic"
    it "should generate a valid TOPIC message if a topic is not specified", ->
      IrcMessageGenerator.topic("#channel").should.equal("TOPIC #channel")
  describe "#names", ->
    it "should generate a valid NAMES message if both a channel and a target are specified", ->
      IrcMessageGenerator.names("#channel", "target.server").should.equal "NAMES #channel target.server"
    it "should generate a valid NAMES message if only a channel is specified", ->
      IrcMessageGenerator.names("#channel").should.equal "NAMES #channel"
    it "should generate a valid NAMES message if neither a channel nor a target are specified", ->
      IrcMessageGenerator.names().should.equal "NAMES"
  describe "#list", ->
    it "should generate a valid LIST message if both a channel and target are specified", ->
      IrcMessageGenerator.list("#channel", "target.server").should.equal "LIST #channel target.server"
    it "should generate a valid LIST message if only a channel is specified", ->
      IrcMessageGenerator.list("#channel").should.equal "LIST #channel"
    it "should generate a valid LIST message if neither a channel nor a target are specified", ->
      IrcMessageGenerator.list().should.equal "LIST"
  describe "#invite", ->
    it "should generate a valid INVITE message", ->
      IrcMessageGenerator.invite("#channel", "test").should.equal "INVITE #channel test"
  describe "#kick", ->
    it "should generate a valid KICK message if a reason is specified", ->
      IrcMessageGenerator.kick("#channel", "test", "Kick reason").should.equal "KICK #channel test :Kick reason"
    it "should generate a valid KICK message if a reason is not specified", ->
      IrcMessageGenerator.kick("#channel", "test").should.equal "KICK #channel test"

  # Section 3.3 - Sending Messages
  describe "#privmsg", ->
    it "should generate a valid PRIVMSG message", ->
      IrcMessageGenerator.privmsg("#channel", "This is a test.").should.equal "PRIVMSG #channel :This is a test."
      IrcMessageGenerator.privmsg("nickname", "This is another test.").should.equal "PRIVMSG nickname :This is another test."
  describe "#notice", ->
    it "should generate a valid NOTICE message", ->
      IrcMessageGenerator.notice("#channel", "This is a test.").should.equal "NOTICE #channel :This is a test."
      IrcMessageGenerator.notice("nickname", "This is another test.").should.equal "NOTICE nickname :This is another test."
  
  # Section 3.4 - Server queries and commands
  describe "#motd", ->
    it "should generate a valid MOTD message if a target is specificed", ->
      IrcMessageGenerator.motd("target.server").should.equal "MOTD target.server"
    it "should generate a valid MOTD if a target is not specified", ->
      IrcMessageGenerator.motd().should.equal "MOTD"
  describe "#lusers", ->
    it "should generate a valid LUSERS message if both a mask and target are specified", ->
      IrcMessageGenerator.lusers("mask", "target.server").should.equal "LUSERS mask target.server"
    it "should generate a valid LUSERS message if only a mask is specified", ->
      IrcMessageGenerator.lusers("mask").should.equal "LUSERS mask"
    it "should generate a valid LUSERS message if neither a mask nor target are specified", ->
      IrcMessageGenerator.lusers().should.equal "LUSERS"
  describe "#version", ->
    it "should generate a valid VERSION message if a target is specified", ->
      IrcMessageGenerator.version("target.server").should.equal "VERSION target.server"
    it "should generate a valid VERSION message if a target is not specified", ->
      IrcMessageGenerator.version().should.equal "VERSION"
  describe "#stats", ->
    it "should generate a valid STATS message if both a query and a target are specified", ->
      IrcMessageGenerator.stats("m", "target.server").should.equal "STATS m target.server"
    it "should generate a valid STATS message if only a query is specified", ->
      IrcMessageGenerator.stats("m").should.equal "STATS m"
    it "should generate a valid STATS message if neither a query nor a target are specified", ->
      IrcMessageGenerator.stats().should.equal "STATS"
  describe "#links", ->
    it "should generate a valid LINKS message if both a server mask and a remote server are specified", ->
      IrcMessageGenerator.links("*.com", "remoteserver.net").should.equal "LINKS remoteserver.net *.com"
    it "should generate a valid LINKS message if only a server mask is specified", ->
      IrcMessageGenerator.links("*.com").should.equal "LINKS *.com"
    it "should generate a valid LINKS message if neither a server mask nor a remote server are specified", ->
      IrcMessageGenerator.links().should.equal "LINKS"
  describe "#time", ->
    it "should generate a valid TIME message if a target server is specified", ->
      IrcMessageGenerator.time("target.server").should.equal "TIME target.server"
    it "should generate a valid TIME message if a target server is not specified", ->
      IrcMessageGenerator.time().should.equal "TIME"
  describe "#connect", ->
    it "should generate a valid CONNECT message if a remote server is specified", ->
      IrcMessageGenerator.connect("server.to.connect.to", 6667, "remote.server").should.equal "CONNECT server.to.connect.to 6667 remote.server"
    it "should generate a valid CONNECT message if a remote server is not specified", ->
      IrcMessageGenerator.connect("server.to.connect.to", 6667).should.equal "CONNECT server.to.connect.to 6667"
  describe "#trace", ->
    it "should generate a valid TRACE message if a target is specified", ->
      IrcMessageGenerator.trace("target.server").should.equal "TRACE target.server"
    it "should generate a valid TRACE message if a target is not specified", ->
      IrcMessageGenerator.trace().should.equal "TRACE"
  describe "#admin", ->
    it "should generate a valid ADMIN message if a target is specified", ->
      IrcMessageGenerator.admin("target.server").should.equal "ADMIN target.server"
    it "should generate a valid ADMIN if a target is not specified", ->
      IrcMessageGenerator.admin().should.equal "ADMIN"
  describe "#info", ->
    it "should generate a valid INFO message if a target is specified", ->
      IrcMessageGenerator.info("target.server").should.equal "INFO target.server"
    it "should generate a valid INFO message if a target is not specified", ->
      IrcMessageGenerator.info().should.equal "INFO"

  # Section 3.5 - Service Query and Commands
  describe "#servlist", ->
    it "should generate a valid SERVLIST message if both a mask and type are specified", ->
      IrcMessageGenerator.servlist("mask", "type").should.equal "SERVLIST mask type"
    it "should generate a valid SERVLIST message if only a mask is specified", ->
      IrcMessageGenerator.servlist("mask").should.equal "SERVLIST mask"
    it "should generatea a valid SERVLIST message if neither a mask nor a type are specified", ->
      IrcMessageGenerator.servlist().should.equal "SERVLIST"
  describe "#squery", ->
    it "should generate a valid SQUERY message", ->
      IrcMessageGenerator.squery("SomeService", "Something").should.equal "SQUERY SomeService :Something"

  # Section 3.6 - User based queries
  describe "#who", ->
    it "should generate a valid WHO message with OpsOny enabled", ->
      IrcMessageGenerator.who("#channel", true).should.equal "WHO #channel o"
    it "should generate a valid WHO message with OpsOnly disabled", ->
      IrcMessageGenerator.who("#channel", false).should.equal "WHO #channel"
  describe "#whois", ->
    it "should generate a valid WHOIS message if a target server is specified", ->
      IrcMessageGenerator.whois("nickname", "target.server").should.equal "WHOIS target.server nickname"
    it "should generate a valid WHOIS message if a target server is not specified", ->
      IrcMessageGenerator.whois("nickname").should.equal "WHOIS nickname"
  describe "#whowas", ->
    it "should generate a valid WHOWAS message if both a target and count are specified", ->
      IrcMessageGenerator.whowas("nickname", 1, "target.server").should.equal "WHOWAS nickname 1 target.server"
    it "should generate a valid WHOWAS message if only a count is specified", ->
      IrcMessageGenerator.whowas("nickname", 1).should.equal "WHOWAS nickname 1"
    it "should generate a valid WHOWAS message if neither a target nor a count is specified", ->
      IrcMessageGenerator.whowas("nickname").should.equal "WHOWAS nickname"

  # Section 3.7 - Miscellaneous messages
  describe "#kill", ->
    it "should generate a valid KILL message", ->
      IrcMessageGenerator.kill("nickname", "Killed for a reason").should.equal "KILL nickname :Killed for a reason"
  describe "#ping", ->
    it "should generate a valid PING message with two servers specified", ->
      IrcMessageGenerator.ping("first.server.com", "second.server.com").should.equal "PING first.server.com second.server.com"
    it "should generate a valid PING message with only one server specified", ->
      IrcMessageGenerator.ping("only.server.com").should.equal "PING only.server.com"
  describe "#pong", ->
    it "should generate a valid PONG message with two servers specified", ->
      IrcMessageGenerator.pong("first.server.com", "second.server.com").should.equal "PONG first.server.com second.server.com"
    it "should generate a valid PONG message with only one server specified", ->
      IrcMessageGenerator.pong("only.server.com").should.equal "PONG only.server.com"
  describe "#error", ->
    it "should generate a valid ERROR message", ->
      IrcMessageGenerator.error("The server is on fire").should.equal "ERROR :The server is on fire"