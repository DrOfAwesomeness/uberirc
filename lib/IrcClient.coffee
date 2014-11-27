events = require "events"
net = require "net"
IrcMessageGenerator = require "./IrcMessageGenerator.coffee"
IrcMessageParser = require "./IrcMessageParser.coffee"

###*
  * This class represents a single connection to an IRC server.
  *
  * @name IrcClient
  * @category Class
###
class IrcClient extends events.EventEmitter
  ###*
    * The IrcClient constructor
    * @constructor
    * @name IrcClient
    * @package IRC Client
    * @category Function
    * @parameter {object} options (The options for the IRC Client)
    * @property {string} options.server (The IRC server to connect to)
    * @property {number} options.port (The port to connect to)
    * @property {string} options.username (The username the IrcClient should use. default: UberIRC)
    * @property {string} options.nick (The nickname the IrcClient should use)
    * @property {string} options.realname (The real name the IrcClient should use. default: An UberIRC Bot)
  ###
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
  ###*
    * Sends a raw message to the IRC server followed by a newline
    * @name _sendRaw
    * @package IRC Client
    * @category Function
    * @parameter {string} message (the message to send)
  ###
  _sendRaw: (message) ->
    @_socket.write "#{message}\n"
  ###*
    * Joins a channel
    * @name join
    * @package IRC Client
    * @category Function
    * @parameter {string} channel (The channel to join)
  ###
  join: (channel) ->
    @_sendRaw @_generator.join(channel)
  ###*
    * Sends a chat message to a user or channel
    * @name chat
    * @package IRC Client
    * @category Function
    * @parameter {string} target (The user or channel to message)
    * @parameter {string} content (The message to send)
  ###
  chat: (target, content) ->
    @_sendRaw @_generator.privmsg(target, content)
  ###*
    * Connects to the IRC Server
    * @name connect
    * @package IRC Client
    * @category Function
  ###
  connect: () ->
    parent = this
    @_socket.on "connect", ->
      parent._sendRaw parent._generator.nick(parent.options.nick)
      parent._sendRaw parent._generator.user(parent.options.username, "0", parent.options.realname)
    @_socket.on "data", (data) ->
      data.toString("utf8").split("\r\n").forEach (messageLine) ->
        if messageLine.length == 0
          return
        ###*
          * Emitted when the client receives a message from the IRC server, prior to parsing.
          * @name raw
          * @package IRC Client
          * @category Event
        ###
        parent.emit "raw", messageLine
        parsedMessage = parent._parser.parseIrcMessage(messageLine)
        if parsedMessage.command
          switch parsedMessage.command
            when "PING"
              ###*
                * Emitted when the client receives a PING message from the IRC server.
                * @name ping
                * @package IRC Client
                * @category Event
                * @type {object}
                * @property {object} origin (An object containing information about the server or user who caused the message to be sent. Contains "server" if the message is from a server or "nick", "username", and "hostname" if the message is from a user)
                * @property {array} parameters (Contains the message's parameters.)
              ###
              parent.emit "ping", parsedMessage
              parent._sendRaw parent._generator.pong parsedMessage.parameters[0]
            when "NOTICE"
              eventObject =
                origin: parsedMessage.origin
                target: parsedMessage.parameters[0]
                content: parsedMessage.parameters[1]
              ###*
                * Emitted when the client receives a NOTICE message from the server
                * @name notice
                * @package IRC Client
                * @category Event
                * @type {object}
                * @property {object} origin (An object containing information about the server or user who caused the message to be sent. Contains "server" if the message is from a server or "nick", "username", and "hostname" if the message is from a user)
                * @property {string} target (The target of the message. If the message was sent to a channel, this will be the name of the channel.)
                * @property {string} content (The content of the NOTICE)
              ###
              parent.emit "notice", eventObject
            when "PRIVMSG"
              eventObject =
                origin: parsedMessage.origin
                target: parsedMessage.parameters[0]
                content: parsedMessage.parameters[1]
              ###*
                * Emitted when the client receives a PRIVMSG message from the server
                * @name chat
                * @package IRC Client
                * @category Event
                * @type {object}
                * @property {object} origin (An object containing information about the server or user who caused the message to be sent. Contains "server" if the message is from a server or "nick", "username", and "hostname" if the message is from a user)
                * @property {string} target (The target of the message. If the message was sent to a channel, this will be the name of the channel.)
                * @property {string} content (The content of the message)
              ###
              parent.emit "chat", eventObject
              parent.emit "chat-" + eventObject.target, eventObject
        else if parsedMessage.replyCode
          if parsedMessage.replyCode.startsWith "ERR"
            parent.emit "error", parsedMessage
          switch parsedMessage.replyCode
            when "RPL_WELCOME"
              ###*
                * Emitted when the client receives the "Welcome" reply from the server
                * @name welcome
                * @package IRC Client
                * @category Event
              ###
              parent.emit "welcome"
            when "RPL_TOPIC"
              ###*
                * Emitted when the client receives a topic (or lack thereof) for a channel from the server
                * @name topic
                * @package IRC Client
                * @category Event
                * @type {object}
                * @property channel {string} (The channel indicated in the reply)
                * @property topic {string} (The channel's topic, if it has one. Undefined if it doesn't)
              ###
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
