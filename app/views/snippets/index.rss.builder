# index.rss.builder
xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Snippy"
    xml.description "Code snippets"
    xml.link snippets_path(:only_path => false)

    for snippet in @snippets
      xml.item do
        xml.title snippet.preview.split("\n").first
        xml.description snippet.formatted_preview
        xml.pubDate snippet.created_at.to_s(:rfc822)
        xml.link snippet_path(snippet)
        xml.guid snippet_path(snippet)
      end
    end
  end
end

