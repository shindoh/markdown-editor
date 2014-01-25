class ResourcesView extends Backbone.View
  initialize: () ->
    @model.on 'change:resources', @render, this

  render: () ->
    resources = @model.get 'resources'

    text = ''
    for resource in resources.models
      text += resource.get('content') + ', '

    @$el.html text

exports.ResourcesView = ResourcesView