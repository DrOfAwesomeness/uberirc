# This file contains the functions that generate the Client->Server IRC messages
# Everything in here comes from RFC 2812
module.exports =
  # Section 3.1 - Connection Registration
  pass: (password) ->
    return "PASS #{password}"
  nick: (nickname) ->
    return "NICK #{nickname}"
  user: (user, mode, realname) ->
    return "USER #{user} #{mode} * :#{realname}"
  oper: (name, password) ->
    return "OPER #{name} #{password}"
  usermode: (nickname, mode) ->
    if mode
      return "MODE #{nickname} #{mode}"
    return "MODE #{nickname}"
  service: (nickname, distribution, type, info) ->
    return "SERVICE #{nickname} * #{distribution} #{type} * :#{info}"
  quit: (quitmessage) ->
    if quitmessage
      return "QUIT :#{quitmessage}"
    return "QUIT"
  squit: (server, comment) ->
    return "SQUIT #{server} :#{comment}"

  # Section 3.2 - Channel operations
  join: (channel, key) ->
    if key
      return "JOIN #{channel} #{key}"
    return "JOIN #{channel}"
  part: (channel, reason) ->
    if reason
      return "PART #{channel} :#{reason}"
    return "PART #{channel}"
  channelmode: (channel, modes, paramaters) ->
    if paramaters
      return "MODE #{channel} #{modes} #{paramaters}"
    if modes
      return "MODE #{channel} #{modes}"
    return "MODE #{channel}"
  topic: (channel, topic) ->
    if topic
      return "TOPIC #{channel} :#{topic}"
    return "TOPIC #{channel}"
  names: (channel, target) ->
    if target
      return "NAMES #{channel} #{target}"
    if channel
      return "NAMES #{channel}"
    return "NAMES"
  list: (channel, target) ->
    if target
      return "LIST #{channel} #{target}"
    if channel
      return "LIST #{channel}"
    return "LIST"
  invite: (nickname, channel) ->
    return "INVITE #{nickname} #{channel}"
  kick: (channel, nickname, reason) ->
    if reason
      return "KICK #{channel} #{nickname} :#{reason}"
    return "KICK #{channel} #{nickname}"

  # 3.3 - Sending messages
  privmsg: (msgtarget, text) ->
    return "PRIVMSG #{msgtarget} :#{text}"
  notice: (msgtarget, text) ->
    return "NOTICE #{msgtarget} :#{text}"

  # 3.4 - Server queries and commands
  motd: (target) ->
    if target
      return "MOTD #{target}"
    return "MOTD"
  lusers: (mask, target) ->
    if target
      return "LUSERS #{mask} #{target}"
    if mask
      return "LUSERS #{mask}"
    return "LUSERS"
  version: (target) ->
    if target
      return "VERSION #{target}"
    return "VERSION"
  stats: (query, target) ->
    if target
      return "STATS #{query} #{target}"
    if query
      return "STATS #{query}"
    return "STATS"
  links: (servermask, remoteserver) ->
    if remoteserver
      return "LINKS #{remoteserver} #{servermask}"
    if servermask
      return "LINKS #{servermask}"
    return "LINKS"
  time: (target) ->
    if target
      return "TIME #{target}"
    return "TIME"
  connect: (target, port, remoteserver) ->
    if remoteserver
      return "CONNECT #{target} #{port} #{remoteserver}"
    return "CONNECT #{target} #{port}"
  trace: (target) ->
    if target
      return "TRACE #{target}"
    return "TRACE"
  admin: (target) ->
    if target
      return "ADMIN #{target}"
    return "ADMIN"
  info: (target) ->
    if target
      return "INFO #{target}"
    return "INFO"

  # 3.5 - Service Query and Commands
  servlist: (mask, type) ->
    if type
      return "SERVLIST #{mask} #{type}"
    if mask
      return "SERVLIST #{mask}"
    return "SERVLIST"
  squery: (servicename, text) ->
    return "SQUERY #{servicename} :#{text}"

  # 3.6 - User based queries
  who: (mask, opsonly) ->
    if opsonly
      return "WHO #{mask} o"
    return "WHO #{mask}"
  whois: (mask, target) ->
    if target
      return "WHOIS #{target} #{mask}"
    return "WHOIS #{mask}"
  whowas: (nickname, count, target) ->
    if target
      return  "WHOWAS #{nickname} #{count} #{target}"
    if count
      return "WHOWAS #{nickname} #{count}"
    return "WHOWAS #{nickname}"

  # 3.7 - Miscellaneous messages
  kill: (nickname, comment) ->
    return "KILL #{nickname} :#{comment}"
  ping: (server1, server2) ->
    if server2
      return "PING #{server1} #{server2}"
    return "PING #{server1}"
  pong: (server1, server2) ->
    if server2
      return "PONG #{server1} #{server2}"
    return "PONG #{server1}"
  error: (errormessage) ->
    return "ERROR :#{errormessage}"
