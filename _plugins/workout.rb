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
    lines = []
    @matches.each { |unit|
      line = (unit[0].nil? ? '' :  (highlight('sets', unit[0]) + 'x')) + 
             highlight('reps', unit[1]) + 
             (unit[2].nil? ? '' :  ('@' + highlight('weight', unit[2]) + 'lb')) 
      lines.push(line)
    }
    wrap_span('workout-unit', lines)

    # "<iframe width=\"#{@width}\" height=\"#{@height}\" src=\"http://www.youtube.com/embed/#{@id}\" frameborder=\"0\"allowfullscreen></iframe>"
    #"<iframe width=\"#{@width}\" height=\"#{@height}\" src=\"http://www.youtube.com/embed/#{@id}?color=white&theme=light\"></iframe>"
  end

  # highlight the number of sets/reps/weight
  def highlight(type, workload)
    wrap_span(type, workload.to_s.split('/'), '/')
  end

  # wrap array elements in spans
  def wrap_span(type, lines, sep=', ')
    '<span class="' + type + '">' + lines.join('</span>' + sep + '<span class="' + type + '">') + '</span>'
  end

  Liquid::Template.register_tag "w", self
end
