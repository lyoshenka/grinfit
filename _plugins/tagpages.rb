module Jekyll

  class TagPage < Page
    def initialize(site, base, dir, tag)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      layout = 'tag.html'
      self.read_yaml(File.join(base, '_layouts'), layout)
      self.data['tag'] = tag
      self.data['title'] = "#{tag}"
      self.data['filter_tag'] = "#{tag}"
    end
  end

  class TagPageGenerator < Generator
    safe true

    def generate(site)
      if site.layouts.key? 'tag'
        site.tags.keys.each do |tag|
          tag_name = tag.gsub(/\s+/, '-')
          site.pages << TagPage.new(site, site.source, '/'+tag_name, tag)
        end
      end
    end
  end

end
