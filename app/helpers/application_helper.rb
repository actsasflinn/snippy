module ApplicationHelper
  def title
    @title || 'Snippy'
  end

  def total_for(count, label = nil)
    label = label.blank? ? count : pluralize(count, label)
    content_tag(:span, "(#{label})", :class => "total")
  end

  def line_numbers(count, lines = [])
    length = count.to_s.length
    count.times{ |i| lines << content_tag(:span, raw("&nbsp;&nbsp;"+sprintf("%0#{length}d", i + 1)+"&nbsp;"), class:"line-numbers") }
    lines.join(tag(:br))
  end

  def tag_score_class(score)
    "tag_#{score}"
  end

  def themes
    Uv.themes
  end
end
