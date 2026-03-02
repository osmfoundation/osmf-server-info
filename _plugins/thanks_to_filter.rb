# frozen_string_literal: true

module Jekyll
  module ThanksToFilter
    def thanks_to(node)
      return node.map { |n| thanks_to(n) } if node.is_a? Array

      ThanksTo.thanks_to(node, @context.registers[:site])
    end
  end
end

Liquid::Template.register_filter(Jekyll::ThanksToFilter)
