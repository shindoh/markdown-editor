escape = (html, encode) ->
  html.replace((if !encode then /&(?!#?\w+;)/g else /&/g), '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#39;')

unescape = (html) ->
  html.replace /&([#\w]+);/g, (_, n) ->
    n = n.toLowerCase()
    if n is 'colon' then return ''
    if n.charAt(0) is '#'
      return (
        if n.charAt(1) is 'x'
        then String.fromCharCode parseInt(n.substring(2), 16)
        else String.fromCharCode +n.substring(1)
      )
    ''

class Renderer
  constructor: (options) ->
    @options = options || {}

  code: (token, code, lang, escaped) ->
    if @options.highlight
      out = @options.highlight code, lang
      if out? and out isnt code
        escaped = true
        code = out

    if !lang
      return
      """
      <pre data-index="#{token.index}"><code>#{if escaped then code else escape(code, true)}
      </code></pre>
      """

    """
    <pre data-index="#{token.index}"><code class="#{@options.langPrefix}#{escape lang, true}">#{if escaped then code else escape(code, true)}
    </code></pre>\n
    """

  blockquote: (token, quote) ->
    """
    <blockquote data-index="#{token.index}">
    #{quote}</blockquote>\n
    """

  html: (token, html) ->
    """
    #{html}
    """

  heading: (token, text, level, raw) ->
    eraw = raw.toLowerCase().replace /[^\w]+/g, '-'
    id = "#{@options.headerPrefix}#{eraw}"

    """
    <h#{level} id="#{id}" data-index="#{token.index}">#{text}</h#{level}>\n
    """

  hr: (token) ->
    """
    <hr data-index="#{token.index}">\n
    """

  list: (token, body, ordered) ->
    type = if ordered then 'ol' else 'ul'
    """
    <#{type} data-index="#{token.index}">
    #{body}
    </#{type}>\n
    """

  listitem: (token, text) ->
    """
    <li data-index="#{token.index}">#{text}</li>\n
    """

  paragraph: (token, text) ->
    """
    <p data-index="#{token.index}">#{text}</p>\n
    """

  table: (token, header, body) ->
    """
    <table data-index="#{token.index}">
    <thead>
    #{header}
    </thead>
    <tbody>
    #{body}
    </tbody>
    </table>
    """

  tablerow: (token, content) ->
    """
    <tr>
    #{content}
    </tr>\n
    """

  tablecell: (token, content, flags) ->
    type = if flags.header then 'th' : 'td'
    if flags.align
      tag = """<#{type} style="text-align: #{flags.align}">"""
    else
      tag = """<#{type}>"""

    """
    #{tag}#{content}</#{type}>\n
    """

  # span level renderer
  strong: (text) ->
    "<strong>#{text}</strong>"

  em: (text) ->
    "<em>#{text}</em>"

  codespan: (text) ->
    "<code>#{text}</code>"

  br: () ->
    "<br>"

  del: (text) ->
    "<del>#{text}</del>"

  link: (href, title, text) ->
    if @options.sanitize
      try
        prot = decodeURIComponent(unescape(href))
          .replace(/[^\w:]/g, '')
          .toLowerCase()
      catch e
        return ''
      if prot.indexOf('javascript:') is 0
        return ''

    """<a href="#{href}" title="#{title}">#{text}</a>"""

  image: (href, title, text) ->
    """<img src="#{href}" alt="#{text}" title="#{title}">"""

exports.Renderer = Renderer