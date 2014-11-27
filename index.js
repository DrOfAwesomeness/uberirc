require('coffee-script').register();
module.exports = {
    IrcMessageGenerator: require('./lib/IrcMessageGenerator.coffee'),
    IrcMessageParser: require('./lib/IrcMessageParser.coffee'),
    IrcClient: require('./lib/IrcClient.coffee')
}
