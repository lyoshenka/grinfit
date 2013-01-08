class Workout < Liquid::Tag
  Syntax = /((?<sets>[\d\/]+)x)?(?<reps>[\d\/]+)(@(?<weight>[\d\/]+))?/

  def initialize(tagName, markup, tokens)
    super

    clean = markup.gsub(/\s+/, '')
    if clean =~ Syntax then
      @matches = clean.scan(Syntax)
    else
      raise "Malformed workout tag: " + markup
    end
  end

  def render(context)
    things = []
    @matches.each { |unit|
      line = ''
      if !unit[0].nil?
        line << '<span class="sets">' << unit[0].to_s << '</span> <span class="sep">x</span> '
      end
      line << '<span class="reps">' << unit[1].to_s << '</span>'
      if !unit[2].nil?
        line << ' <span class="sep">@</span> <span class="weight">' << unit[2].to_s << 'lb</span>'
      end
      things.push(line)
    }
    things.join(', ')

    # "<iframe width=\"#{@width}\" height=\"#{@height}\" src=\"http://www.youtube.com/embed/#{@id}\" frameborder=\"0\"allowfullscreen></iframe>"
    #"<iframe width=\"#{@width}\" height=\"#{@height}\" src=\"http://www.youtube.com/embed/#{@id}?color=white&theme=light\"></iframe>"
  end

  Liquid::Template.register_tag "w", self
end
