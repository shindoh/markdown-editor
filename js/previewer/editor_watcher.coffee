# Markdown Previewer for PageDown

# TODO fix compatibility
getScrollHeight = (obj) ->
  return obj[0].scrollHeight;

class EditorWatcher
  constructor: (converter) ->
    @converter = converter
    @ace_editor = null

  setup: (ace_editor, preview_view) ->
    @ace_editor = ace_editor;
    @preview_view = preview_view

    @ace_editor.session.on 'changeScrollTop', @syncScroll.bind(this)
    @ace_editor.session.selection.on 'changeCursor', @syncScroll.bind(this)
    setInterval @watch.bind(this), 1000

  syncScroll: () ->
    editor_scroll_range = @ace_editor.session.getLength()
    preview_scroll_range = getScrollHeight @preview_view
    scroll_factor = @ace_editor.getFirstVisibleRow() / editor_scroll_range
    @preview_view.scrollTop scroll_factor * preview_scroll_range

  watch: () ->
    cur_input = @ace_editor.getValue()
    if @old_input isnt cur_input
      html = @makeHtml cur_input
      @preview_view.html html

    @old_input = cur_input

  makeHtml: (markdown) ->
    @converter.makeHtml markdown

root = exports ? this
root.EditorWatcher = EditorWatcher