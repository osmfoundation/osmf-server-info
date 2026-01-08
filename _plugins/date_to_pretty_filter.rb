# frozen_string_literal: true

require "date"

module Jekyll
  module DateToPrettyFilter
    def date_to_pretty(input)
      return "" if input.nil?

      date = Time.at(input)
      today = Date.today
      date_day = date.to_date

      return date.strftime("%H:%M") if date_day == today
      return "Yesterday" if date_day == today - 1
      return date.strftime("%e %B") if date_day.year == today.year

      date.strftime("%e %B %Y")
    end
  end
end

Liquid::Template.register_filter(Jekyll::DateToPrettyFilter)
