###*
  * This class represents an IRC message
  * @name IrcMessage
  * @category Class
  * @package IRC Message
###
class IrcMessage
  ###*
    * The origin of the IRC message
    * @name Origin
    * @package IRC Message
    * @category Object
    * @type {object}
    * @property isServer {boolean} (True if the message is a server action, such as a numeric reply. False if it is a user action, such as a message to a channel.)
    * @property server {string} (The name of the server if the origin is a server.)
    * @property nick {string} (The nickname of the user if the origin is a user.)
    * @property username {string} (The username of the user if the origin is a user.)
    * @property hostname {string} (The hostname of the user if the origin is a user.)
  ###
  origin: {}
  ###*
    * True if the message is a numeric reply.
    * @name numeric
    * @category Boolean
    * @package IRC Message
    * @type {boolean}
  ###
  numeric: false
  ###*
    * Contains the reply number if the message is a numeric reply.
    * @name replyNum
    * @category Number
    * @package IRC Message
    * @type {number}
  ###
  replyNum: null
  ###*
    * Contains the reply code if the message is a numeric reply.
    * @name replyCode
    * @category String
    * @package IRC Message
    * @type {string}
  ###
  replyCode: null
  ###*
    * Contains the IRC message parameters.
    * @name parameters
    * @category Array
    * @package IRC Message
    * @type {array}
  ###
  parameters: []
module.exports = IrcMessage