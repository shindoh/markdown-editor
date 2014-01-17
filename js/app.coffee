$ ->
  # jQuery Layout Plugin
  $('body').layout {
    west__size: .5,
    applyDefaultStyles: true,

    # Fires when layout is resized
    onresize: () ->
      aceEditor.resize()
  }

  previewView = $('#preview-view')

  # Apply Markdown
  markdownConverter = new Markdown.Converter

  aceEditor = ace.edit 'editor-view'
  aceEditor.getSession().setMode "ace/mode/markdown"

  editorWatcher = new EditorWatcher markdownConverter
  editorWatcher.setup aceEditor, previewView
