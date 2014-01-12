# Markdown Previewer for PageDown

class EditorWatcher
  constructor: (converter) ->
    @converter = converter
    @input_ = null

  setup: (input, previewCallback) ->
    @input_ = input;
    @previewCallback_ = previewCallback
    setInterval @watch.bind(this), 1000

  watch: () ->
    cur_input = @input_.getValue()
    if @old_input_ isnt cur_input
      html = @makeHtml cur_input
      @previewCallback_ html

    @old_input = cur_input

  makeHtml: (markdown) ->
    @converter.makeHtml markdown

root = exports ? this
root.EditorWatcher = EditorWatcher