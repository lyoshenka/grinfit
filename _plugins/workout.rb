class Workout < Liquid::Tag

  def initialize(tagName, markup, tokens)
    super
    @text = markup
  end

  def render(context)
    '<span class="workout-unit">' + @text.gsub(/(\d+)/, '<span class="number">\1</span>') + '</span>'
  end

  Liquid::Template.register_tag "w", self
end
