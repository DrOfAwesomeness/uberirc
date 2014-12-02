# UberIRC [![Build Status](https://travis-ci.org/UberIRC/uberirc.svg?branch=master)](https://travis-ci.org/UberIRC/uberirc)
---
**NOTICE: UberIRC is currently in the early stages of development. Stuff will break as features are developed and versions are released. Nothing should be considered stable until version 1.0.0 is released.**

UberIRC is a Node.js IRC client module written in [CoffeeScript](http://coffeescript.org). It's goal is to replace the widely-used '[irc](http://npmjs.org/package/irc)' module. 

## Example
Javascript:
```javascript
var IrcClient = require("uberirc").IrcClient,
    client = new IrcClient({
        server: "chat.freenode.net",
        nick: "examplebot"
    });
client.on('welcome', function() {
  client.join("#uberirc");
  client.chat("#uberirc", "Hello, world!");
});
client.on('chat', function(e) {
    if (e.target == "#uberirc" && e.content == "!hello") {
      client.chat("#uberirc", "Hello!");
    }
});
client.connect();
```
CoffeeScript:
```coffeescript
IrcClient = require("uberirc").IrcClient
client = new IrcClient
  server: "chat.freenode.net"
  nick: "examplebot"
client.on "welcome", ->
  client.join "#uberirc"
  client.chat "#uberirc", "Hello, world!"
client.on "chat", (e) ->
  if e.target is "#uberirc" and e.content is "!hello"
    client.chat "#uberirc", "Hello!"
client.connect()
```