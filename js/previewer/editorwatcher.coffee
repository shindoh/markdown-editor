# Markdown Previewer for Marked

# Constants
DELAYED_SCROLL_TIME_MS = 10
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
    @oldFocusedElement = null

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

    # add focus to selected element
    if @oldFocusedElement?
      $(@oldFocusedElement).removeClass 'selected-element'

    if beginElement is null
      return

    $(beginElement).addClass 'selected-element'
    @oldFocusedElement = beginElement

    # sync scroll if element is invisible from view
    previewViewOffset = @previewView.offset()
    previewViewOffset.height = @previewView.outerHeight(true)
    previewViewOffset.bottom = previewViewOffset.top + previewViewOffset.height

    previewViewPadding = @previewView.outerHeight(true) - @previewView.height()

    beginElementOffset = $(beginElement).offset()
    beginElementOffset.height = $(beginElement).outerHeight(true)
    beginElementOffset.bottom = beginElementOffset.top + beginElementOffset.height

    if beginElementOffset.bottom < previewViewOffset.top || beginElementOffset.top > previewViewOffset.bottom
      curOffset = @previewView.scrollTop() + beginElementOffset.top\
                  - previewViewOffset.top - previewViewPadding
      @previewView.stop().animate {
        scrollTop: curOffset
      }, 500, "easeInOutCubic"

  makePreview: () ->
    curSource = @aceEditor.getValue()
    if @oldSource isnt curSource
      html = @converter curSource
      @previewView.html html

    @oldSource = curSource
    @syncScroll()

root = exports ? this
root.EditorWatcher = EditorWatcher