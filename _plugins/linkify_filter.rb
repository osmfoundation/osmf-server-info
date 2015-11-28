module Jekyll
  module LinkifyFilter
    def linkify(input, group)
      site = @context.registers[:site]

      if url = site.data['urls'][group][input]
        "<a href='#{url}'>#{input}</a>"
      else
        input
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::LinkifyFilter)
