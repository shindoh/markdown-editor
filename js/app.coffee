$ ->
  # Layout
  $('body').layout {
    west__size: .5,
    applyDefaultStyles: true
  }

  # Apply Markdown
  markdown_converter = new Markdown.Converter
  markdown_editor = new Markdown.Editor markdown_converter

  ace_editor = ace.edit 'wmd-input'
  markdown_editor.run ace_editor
