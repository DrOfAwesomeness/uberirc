events = require "events"
net = require "net"
IrcMessageGenerator = require "./IrcMessageGenerator.coffee"
IrcMessageParser = require "./IrcMessageParser.coffee"

class IrcClient extends events.EventEmitter
  constructor: (@options={}) ->
    if !@options.server
      throw new Error "Server not specified"
    if !@options.nick
      throw new Error "Nick not specified"
    @options.port = @options.port | 6667
    @options.username = @options.username | "UberIRC"
    @options.realname = @options.realname | "A UberIRC Bot"
    @_generator = IrcMessageGenerator
    @_parser = IrcMessageParser
    @_socket = new net.Socket {}
  _sendRaw: (message) ->
    @_socket.write "#{message}\n"
  join: (channel) ->
    @_sendRaw @_generator.join(channel)
  chat: (target, content) ->
    @_sendRaw @_generator.privmsg(target, content)
  connect: () ->
    parent = this
    @_socket.on "connect", ->
      parent._sendRaw parent._generator.nick(parent.options.nick)
      parent._sendRaw parent._generator.user(parent.options.username, "0", parent.options.realname)
    @_socket.on "data", (data) ->
      data.toString("utf8").split("\r\n").forEach (messageLine) ->
        if messageLine.length == 0
          return
        parent.emit "raw", messageLine
        parsedMessage = parent._parser.parseIrcMessage(messageLine)
        if parsedMessage.command
          switch parsedMessage.command
            when "PING"
              parent.emit "ping", parsedMessage
              parent._sendRaw parent._generator.pong parsedMessage.parameters[0]
            when "NOTICE"
              eventObject =
                origin: parsedMessage.origin
                target: parsedMessage.parameters[0]
                content: parsedMessage.parameters[1]
              parent.emit "notice", eventObject
            when "PRIVMSG"
              eventObject =
                origin: parsedMessage.origin
                target: parsedMessage.parameters[0]
                content: parsedMessage.parameters[1]
              parent.emit "chat", eventObject
              parent.emit "chat-" + eventObject.target, eventObject
        else if parsedMessage.replyCode
          if parsedMessage.replyCode.startsWith "ERR"
            parent.emit "error", parsedMessage
          switch parsedMessage.replyCode
            when "RPL_WELCOME"
              parent.emit "welcome"
            when "RPL_TOPIC"
              eventObject =
                channel: parsedMessage.parameters[0]
                topic: parsedMessage.parameters[1]
              parent.emit "topic", eventObject
            when "RPL_NOTOPIC"
              eventObject =
                channel: parsedMessage.parameters[0]
              parent.emit "topic", eventObject
    @_socket.connect @options.port, @options.server
module.exports = IrcClient
