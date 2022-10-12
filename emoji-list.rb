#!/usr/bin/env ruby

# Get Emoji list from GitHub API and render README.md

require 'open-uri'
require 'date'
require 'json'

N_COL = 3

def render_markdown(json, date)
  open('README.md', 'w') do |f|
    all_names = json.keys.sort
    f.puts '# GitHub Emoji List'
    f.puts
    f.puts "(retrieved #{date}, #{all_names.size} characters)"
    f.puts
    f.puts '|' + ' `:name:`<br>emoji PNG |' * N_COL
    f.puts '|' + ' :-: |' * N_COL
    until all_names.empty?
      names = all_names.shift(N_COL)
      f.puts '|' + names.map {|name|
        url = json[name]
        " `:#{name}:`<br>:#{name}: [![#{name}](#{url})](#{url}) |"
      }.join('')
    end
  end
end

URI.open 'https://api.github.com/emojis' do |f|
  render_markdown JSON[f.read], Date.today
end
