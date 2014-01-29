editorWatcher = require('./previewer/editorwatcher.js')
markDoc = require('./model/markdoc.js')

initApp = (ace, marked) ->
  # jQuery Layout Plugin
  $('body').layout {
    west: {
      size: .5,
      slidable: false,
      closable: false
    },
    east: {
      size: 150,
      slidable: true,
      initClosed: true
    },
    applyDefaultStyles: true,

    # Fires when layout is resized
    onresize: () ->
      aceEditor.resize()
  }

  markDoc = new markDoc.MarkDoc()

  marked.setOptions {
    renderer: new marked.Renderer(),
    gfm: true,
    tables: true,
    breaks: true,
    pendatic: false,
    sanitize: true,
    smartLists: true,
    smartypants: true
  }

  disableBrowserFunctions = () ->
    $(document).bind 'contextmenu', (e) ->
      e.preventDefault()

  # Disable Browser functions
  disableBrowserFunctions()

  converter = marked
  previewView = $('#preview-view')

  aceEditor = ace.edit 'editor-view'
  aceEditor.getSession().setMode 'ace/mode/markdown'

  editorWatcher = new editorWatcher.EditorWatcher converter, markDoc
  editorWatcher.setup aceEditor, previewView

exports.initApp = initApp;