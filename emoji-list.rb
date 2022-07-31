require 'date'
require 'json'

N_COL = 3
JSON_FILE = 'emoji-list.json'

def get_emoji_list(token)
  unless system "curl -H 'Accept: application/vnd.github+json' -H 'Authorization: token #{token}' https://api.github.com/emojis > #{JSON_FILE}"
    STDERR.puts 'GitHub API Error'
    exit($?)
  end
  File.read(JSON_FILE)
end

def render_markdown(json, date)
  open 'README.md', 'w' do |f|
    f.puts "# GitHub Emoji List\n"
    f.puts "(retrieved #{date})\n"
    for i in (0...N_COL)
      f.print "| name "
    end
    f.puts "|"
    for i in (0...N_COL)
      f.print "| :---: "
    end
    f.puts "|"
    for i in (0...N_COL)
      f.print "| **small \\| LARGE** "
    end
    f.puts "|"

    markup = ""
    icons = ""
    json.keys.sort.each_with_index do |key, index|
      if index != 0 && index % N_COL == 0 then
        f.puts "#{markup}|"
        f.puts "#{icons}|"
        markup = ""
        icons = ""
      end
      markup += "| `#{key}` "
      icons += "| :#{key}: \\| ![#{key}](#{json[key]}) "
    end
    f.puts "#{markup}|"
    f.puts "#{icons}|"
  end
end

# main
STDOUT.print "GitHub token: "
STDOUT.flush
token = gets.chomp
json_str = get_emoji_list(token)
render_markdown(JSON[json_str], Date.today)
