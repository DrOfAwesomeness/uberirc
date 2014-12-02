should = require("chai").should()
IrcMessageParser = require("../lib/IrcMessageParser.coffee")

describe "IrcMessageParser", ->
  describe "#parseIrcMessage", ->
    it "should properly parse numeric replies", ->
      welcome = IrcMessageParser.parseIrcMessage ":server.foonet.net 001 nickname :Welcome to the Foonet IRC Network nickname"
      ircopsonline = IrcMessageParser.parseIrcMessage ":server.foonet.net 252 nickname 30 :IRC Operators online"
      welcome.replyNum.should.equal "001"
      welcome.replyCode.should.equal "RPL_WELCOME"
      ircopsonline.replyNum.should.equal "252"
      ircopsonline.replyCode.should.equal "RPL_LUSEROP"
    it "should properly parse message origins", ->
      servermessage = IrcMessageParser.parseIrcMessage ":server.foonet.net NOTICE * :*** Looking up your hostname"
      usermessage = IrcMessageParser.parseIrcMessage ":someone!~someone@google.com PRIVMSG #channel :Hello, all!"
      servermessage.origin.isServer.should.equal true
      servermessage.origin.server.should.equal "server.foonet.net"
      usermessage.origin.isServer.should.equal false
      usermessage.origin.username.should.equal "~someone"
      usermessage.origin.nick.should.equal "someone"
      usermessage.origin.hostname.should.equal "google.com"
    it "should properly parse chat messages sent to channels", ->
      channelmessage = IrcMessageParser.parseIrcMessage ":someone!~someone@google.com PRIVMSG #channel :Hello, all!"
      channelmessage.origin.isServer.should.equal false
      channelmessage.origin.nick.should.equal "someone"
      channelmessage.origin.username.should.equal "~someone"
      channelmessage.origin.hostname.should.equal "google.com"
      channelmessage.command.should.equal "PRIVMSG"
      channelmessage.parameters[0].should.equal "#channel"
      channelmessage.parameters[1].should.equal "Hello, all!"
    it "should properly parse chat messages sent to users", ->
      channelmessage = IrcMessageParser.parseIrcMessage ":someone!~someone@google.com PRIVMSG nickname :The magic word is 'secret'"
      channelmessage.origin.isServer.should.equal false
      channelmessage.origin.nick.should.equal "someone"
      channelmessage.origin.username.should.equal "~someone"
      channelmessage.origin.hostname.should.equal "google.com"
      channelmessage.command.should.equal "PRIVMSG"
      channelmessage.parameters[0].should.equal "nickname"
      channelmessage.parameters[1].should.equal "The magic word is 'secret'"