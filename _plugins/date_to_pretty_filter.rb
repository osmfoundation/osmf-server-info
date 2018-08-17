module Jekyll
  module DateToPrettyFilter
    def date_to_pretty(input)
      if input.nil?
        ""
      else
        date = Time.at(input)
        now = Time.now

        if now - date <= 43200
          date.strftime("%H:%M")
        elsif now.year == date.year && now.month == date.month && now.day == date.day
          date.strftime("%H:%M")
        elsif now.year == date.year && now.month == date.month && now.day == date.day + 1
          "Yesterday"
        elsif now.year == date.year
          date.strftime("%e %B")
        else
          date.strftime("%e %B %Y")
        end
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::DateToPrettyFilter)
