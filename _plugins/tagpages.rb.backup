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

  class TagPager < Paginate::Pager
    attr_reader :tag
    attr_accessor :tag_base_path

    def initialize(site, page, all_posts, tag, num_pages = nil)
      @tag = tag
      super site, page, all_posts, num_pages
    end

    alias_method :original_to_liquid, :to_liquid

    def to_liquid
      liquid = original_to_liquid
      liquid['tag'] = @tag
      liquid['tag_base_path'] = @tag_base_path
      liquid
    end
  end

  class TagPageGenerator < Generator
    safe true

    def generate(site)
      if site.layouts.key? 'tag'
        site.tags.keys.each do |tag|
          #tag_name = tag.gsub(/\s+/, '-')
          #site.pages << TagPage.new(site, site.source, '/'+tag_name, tag)
          paginate(site, tag)
        end
      end
    end

    def paginate(site, tag)
      tag_posts = site.posts.docs.find_all {|post| post.data['tags'].include?(tag)}.sort_by {|post| -post.date.to_f}
      num_pages = TagPager.calculate_pages(tag_posts, site.config['paginate'].to_i)

      (1..num_pages).each do |page|
        pager = TagPager.new(site, page, tag_posts, tag, num_pages)
        basePath = tag # if you want to move the tags to a subdirectory, do that here
        pager.tag_base_path = "/#{basePath}"
        dir = File.join(basePath, page > 1 ? "page#{page}" : '')
        page = TagPage.new(site, site.source, dir, tag)
        page.pager = pager
        site.pages << page
      end
    end
  end
end
