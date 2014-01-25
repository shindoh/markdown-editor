# Document Class
class ResourceModel extends Backbone.Model
  defaults: {
    content: 'Hello!'
  }

class ResourceCollection extends Backbone.Collection
  model: ResourceModel

class MarkDoc extends Backbone.Model
  defaults: {
    text: '',
    resources: new ResourceCollection()
  },
  initialize: () ->
    @get('resources').bind 'change', () =>
      @trigger 'change:resources'
      @trigger 'change'

exports.MarkDoc = MarkDoc
exports.ResourceModel = ResourceModel