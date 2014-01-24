# Document Class
class MarkDoc
  constructor: () ->
    @resources = {};
    @text = ''

  setText: (text) ->
    @text = text

  getText: () ->
    @text

  addResource: (name, buffer) ->
    @resources[name] = buffer

  removeResource: (name) ->
    delete @resources[name]

  getResources: () ->
    @resources

exports.MarkDoc = MarkDoc