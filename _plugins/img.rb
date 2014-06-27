class ImgTag < Liquid::Tag

  def initialize(tagName, markup, tokens)
    super
    @text = markup
  end

  def render(context)
    link = 'http://i.grin.io/' + @text
    '<a href="' + link + '"><img src="' + link + '" /></a>'
  end

  Liquid::Template.register_tag "img", self
end
