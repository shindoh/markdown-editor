# Markdown Previewer for Marked

# Constants
DELAYED_SCROLL_TIME_MS = 200
DELAYED_PREVIEW_TIME_MS = 200

# TODO fix compatibility
getScrollHeight = (obj) ->
  obj[0].scrollHeight;

class EditorWatcher
  constructor: (converter, markDocument) ->
    @converter = converter
    @aceEditor = null
    @delayedPreviewCall = null
    @delayedScrollCall = null
    @oldSource = null
    @markDocument = markDocument

  setup: (aceEditor, previewView) ->
    @aceEditor = aceEditor;
    @previewView = previewView

#    @aceEditor.getSession().on 'changeScrollTop', @onChangeCursor.bind this
    @aceEditor.getSession().getSelection().on 'changeCursor', @onChangeCursor.bind this
    @aceEditor.getSession().on 'change', @onChangeEditor.bind this

  onChangeEditor: (e) ->
    # Reflect textEditor value to markDoc
    @markDocument.set 'text', @aceEditor.getValue()

    # Clear previous delayed call
    if @delayedPreviewCall?
      clearTimeout @delayedPreviewCall
    @delayedPreviewCall = setTimeout @makePreview.bind(this), DELAYED_PREVIEW_TIME_MS

  onChangeCursor: (e) ->
    if @delayedScrollCall?
      clearTimeout @delayedScrollCall
    @delayedScrollCall = setTimeout @syncScroll.bind(this), DELAYED_SCROLL_TIME_MS

  syncScroll: () ->
    cursorPosition = @aceEditor.getSession().getSelection().getCursor()
    cursorIndex = @aceEditor.getSession().getDocument().positionToIndex(cursorPosition, 0)
    editorScrollRange = @aceEditor.getSession().getLength()
    previewScrollRange = getScrollHeight @previewView

    # Find position candidates
    beginElement = null;
    endElement = null;

    spyCandidates = @previewView.children '[data-index]'
    spyCandidates.each (i, element) ->
      dataIndex = $(element).attr 'data-index'
      if dataIndex is 'undefined'
        return true # continue
      # dataIndex to integer
      dataIndex = parseInt dataIndex
      if dataIndex < 0
        return true # continue

      if dataIndex <= cursorIndex
        beginElement = element
        return true # continue
      if beginElement isnt null and dataIndex >= cursorIndex
        endElement = element
        return false # break

#    scrollFactor = @aceEditor.getFirstVisibleRow() / editorScrollRange
#    @previewView.stop().animate {
#      scrollTop: previewScrollRange * scrollFactor
#    }, 100

  makePreview: () ->
    curSource = @aceEditor.getValue()
    if @oldSource isnt curSource
      html = @converter curSource
      @previewView.html html

    @oldSource = curSource

root = exports ? this
root.EditorWatcher = EditorWatcher