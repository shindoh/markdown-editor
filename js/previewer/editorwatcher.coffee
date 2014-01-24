# Markdown Previewer for Marked

# Constants
DELAYED_PREVIEW_TIME_MS = 200

# TODO fix compatibility
getScrollHeight = (obj) ->
  obj[0].scrollHeight;

class EditorWatcher
  constructor: (converter, markDoc) ->
    @converter = converter
    @aceEditor = null
    @delayedPreviewCall = null
    @oldSource = null
    @markDoc = markDoc

  setup: (aceEditor, previewView) ->
    @aceEditor = aceEditor;
    @previewView = previewView

    @aceEditor.getSession().on 'changeScrollTop', @syncScroll.bind this
    @aceEditor.getSession().selection.on 'changeCursor', @syncScroll.bind this
    @aceEditor.getSession().on 'change', @onChangeEditor.bind this

  onChangeEditor: (obj) ->
    # Reflect textEditor value to markDoc
    @markDoc.setText @aceEditor.getValue()
    
    # Clear previous delayed call
    if @delayedPreviewCall isnt null then clearTimeout @delayedPreviewCall
    @delayedPreviewCall = setTimeout @makePreview.bind(this), DELAYED_PREVIEW_TIME_MS

  syncScroll: () ->
    editorScrollRange = @aceEditor.getSession().getLength()
    previewScrollRange = getScrollHeight @previewView
    scrollFactor = @aceEditor.getFirstVisibleRow() / editorScrollRange
    @previewView.stop().animate {
      scrollTop: previewScrollRange * scrollFactor
    }, 100

  makePreview: () ->
    curSource = @aceEditor.getValue()
    if @oldSource isnt curSource
      html = @converter curSource
      @previewView.html html

    @oldSource = curSource

root = exports ? this
root.EditorWatcher = EditorWatcher