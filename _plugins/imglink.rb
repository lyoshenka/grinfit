class ImgUrl < Liquid::Tag

  def initialize(tagName, markup, tokens)
    super
    @text = markup
  end

  def render(context)
    'http://i.grin.io/' + @text
  end

  Liquid::Template.register_tag "imgurl", self
end
