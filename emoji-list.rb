require 'date'
require 'json'

N_COL = 3
JSON_FILE = 'emoji-list.json'

def get_emoji_list(token)
  unless system "curl -H \"Accept: application/vnd.github+json\" -H \"Authorization: token #{token}\" https://api.github.com/emojis > #{JSON_FILE}"
    STDERR.puts 'GitHub API Error'
    exit($?)
  end
  File.read(JSON_FILE)
end

def render_markdown(json, date)
  open 'README.md', 'w' do |f|
    f.puts "# GitHub Emoji List"
    f.puts
    f.puts "(retrieved #{date})"
    f.puts
    f.puts((0...N_COL).inject("|") {|row, _| row + " name |" })
    f.puts((0...N_COL).inject("|") {|row, _| row + " :-: |" })
    f.puts((0...N_COL).inject("|") {|row, _| row + " **small \\| LARGE** |" })
    all_names = json.keys.sort
    until all_names.empty?
      names = all_names.shift(N_COL)
      f.puts(names.inject("|") {|row, name| row + " `#{name}` |" })
      f.puts(names.inject("|") {|row, name| row + " :#{name}: \\| ![#{name}](#{json[name]}) |" })
    end
  end
end

# main
STDOUT.print "GitHub token: "
STDOUT.flush
token = gets.chomp
json_str = get_emoji_list(token)
render_markdown(JSON[json_str], Date.today)
