#!/usr/bin/env ruby

# Retrieve Emoji list from GitHub and render README.md

require 'date'
require 'json'

N_COL = 3
JSON_FILE = 'emoji-list.json'

# Retrieve Emoji list using GitHub REST API
# (See: https://docs.github.com/en/rest/emojis)
def get_emoji_list(token)
  unless system %Q(curl -H "Accept: application/vnd.github+json" -H "Authorization: token #{token}" https://api.github.com/emojis > #{JSON_FILE})
    STDERR.puts 'GitHub API Error'
    exit $?
  end
  File.read(JSON_FILE)
end

# Render README.md
def render_markdown(json, date)
  open('README.md', 'w') do |f|
    all_names = json.keys.sort
    f.puts "# GitHub Emoji List"
    f.puts
    f.puts "(retrieved #{date}, #{all_names.size} characters)"
    f.puts
    f.puts (0...N_COL).inject("|") {|row, _| row + " `:name:`<br>emoji PNG |" }
    f.puts (0...N_COL).inject("|") {|row, _| row + " :-: |" }
    until all_names.empty?
      names = all_names.shift(N_COL)
      f.puts names.inject("|") {|row, name|
        url = json[name]
        row + " `:#{name}:`<br>:#{name}: [![#{name}](#{url})](#{url}) |"
      }
    end
  end
end

# main
STDOUT.print "GitHub token: "
STDOUT.flush
token = STDIN.gets.chomp
json_str = get_emoji_list token
render_markdown JSON[json_str], Date.today
