# https://gist.github.com/1850654

require 'json'

module JsonFilter
  def json(input)
    input.to_json
  end

  Liquid::Template.register_filter self
end
