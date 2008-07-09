module ApplicationHelper
  def total_for(count, label = nil)
    label = label.blank? ? count : pluralize(count, label)
    content_tag(:span, "(#{label})", :class => "total")
  end

  def line_numbers(count, lines = [])
    count.times{ |i| lines << content_tag(:span, i + 1) }
    lines.join(tag(:br))
  end
end
