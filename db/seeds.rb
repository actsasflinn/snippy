# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

languages = [
  ["shell-unix-generic", "Shell Script (Bash)", "source.shell"],
  ["ruby_on_rails", "Ruby (on Rails)", "source.ruby.rails"],
  ["sql", "SQL", "source.sql"],
  ["sql_rails", "SQL (Rails)", "source.sql.ruby"],
  ["css", "CSS", "source.css"],
  ["plain_text", "Plain text", "text.plain"],
  ["ruby", "Ruby", "source.ruby"],
  ["html_rails", "HTML (Rails)", "text.html.ruby"],
  ["html", "HTML / XML", "text.html.basic"],
  ["javascript", "JavaScript", "source.js"],
  ["java", "Java", "source.java"],
  ["diff", "Diff", "source.diff"],
  ["yaml", "YAML", "source.yaml"],
  ["ruby_experimental", "Ruby (Experimental)", "source.ruby.experimental"],
  ["regexp", "Regexp", "source.regexp"],
  ["json", "JSON", "source.json"],
  ["jquery_javascript", "JavaScript (jQuery)", "source.js.jquery"],
  ["javascript_+_prototype", "JavaScript (Prototype)", "source.js.prototype"],
  ["csv", "Comma Separated Values", "text.tabular.csv"],
  ["apache", "Apache", "source.apache-config"],
  ["ssh-config", "SSH Config", "source.ssh-config"],
  ["textile", "Textile", "text.html.textile"]
]

languages.each{ |l| Language.create(:slug => l[0], :name => l[1], :syntax => l[2])}
