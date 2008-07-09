desc "Bootstrap"
task :bootstrap => :environment do
  puts "Generating Initial Languages"

  languages = {
    "shell-unix-generic" => "Shell Script (Bash)",
    "ruby_on_rails" => "Ruby (on Rails)",
    "sql" => "SQL",
    "sql_rails" => "SQL (Rails)",
    "css" => "CSS",
    "plain_text" => "Plain text",
    "ruby" => "Ruby",
    "html_rails" => "HTML (Rails)",
    "html" => "HTML / XML",
    "javascript" => "JavaScript",
    "java" => "Java",
    "diff" => "Diff",
    "yaml" => "YAML",
    "ruby_experimental" => "Ruby (Experimental)",
    "regexp" => "Regexp",
    "json" => "JSON",
    "jquery_javascript" => "JavaScript (jQuery)",
    "javascript_+_prototype" => "JavaScript (Prototype)",
    "csv" => "Comma Separated Values",
    "apache" => "Apache",
    "ssh-config" => "SSH Config",
    "textile" => "Textile"
  }

  languages.each_pair{ |slug,name| Language.create(:slug => slug, :name => name)}
end
