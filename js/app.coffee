fooRenderer = require('./lib/foo-renderer.js')
editorWatcher = require('./previewer/editorwatcher.js')
markDoc = require('./model/markdoc.js')
resourcesView = require('./views/resourcesview.js')

initApp = (ace, marked) ->
  # jQuery Layout Plugin
  $('body').layout {
    west: {
      size: .5,
      closable: false
    },
    east: {
      size: 200,
#      initClosed: true
    },
    applyDefaultStyles: true,

    # Fires when layout is resized
    onresize: () ->
      aceEditor.resize()
  }

  doc = new markDoc.MarkDoc()
  doc.set 'test1', null
  doc.set 'test2', 'this is text'

  resourcesView = new resourcesView.ResourcesView
    model: doc
  resourcesView.setElement $('#resource-panel')
  resourcesView.render()

  resources = doc.get 'resources'
  resource_model = new markDoc.ResourceModel()
  resources.add resource_model
  resource_model.set 'content', 'This is world'

  marked.setOptions {
    renderer: new fooRenderer.Renderer(),
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

  editorWatcher = new editorWatcher.EditorWatcher converter, doc
  editorWatcher.setup aceEditor, previewView

exports.initApp = initApp;