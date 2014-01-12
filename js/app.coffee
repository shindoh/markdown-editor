$ ->
  # Layout
  $('body').layout {
    west__size: .5,
    applyDefaultStyles: true
  }

  preview_view = $('#preview-view')

  # Callback
  preview_callback = (html) ->
    preview_view.html html

  # Apply Markdown
  markdown_converter = new Markdown.Converter

  ace_editor = ace.edit 'editor-view'
  editor_watcher = new EditorWatcher markdown_converter
  editor_watcher.setup ace_editor, preview_callback
