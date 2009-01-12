module Merb
  module GlobalHelpers
    def title
      @title || 'Snippy'
    end

    def total_for(count, label = nil)
      label = label.blank? ? count : "#{count} #{label}"
      tag(:span, "(#{label})", :class => "total")
    end

    def line_numbers(count, lines = [])
      count.times{ |i| lines << tag(:span, i + 1) }
      lines.join(tag(:br))
    end
  end
end
