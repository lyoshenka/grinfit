class ImgTag < Liquid::Tag

  def initialize(tagName, markup, tokens)
    super
   
    parts = markup.split(' ', 3)

    @link = false
    @filename = parts.shift

    if @filename == ':link'
      @link = true
      @filename = parts.shift
    end

    @text = parts.join(' ').strip

#    puts [@link, @filename, @text]
  end

  def render(context)
    url = 'http://i.grin.io/' + @filename
    if @link
      '<a href="%s">%s</a>' % [url, @text]
    else
      '<a href="%s"><img src="%s" alt="%s" title="%s" /></a>' % [url, url, @text, @text]
    end
  end

  Liquid::Template.register_tag "img", self
end
