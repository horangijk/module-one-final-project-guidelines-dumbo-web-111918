require 'bundler'
Bundler.require

prompt = TTY::Prompt.new
options = ["Razor", "TV", "Razor"]
system "clear"
choices = prompt.multi_select("What would you like to delete? ", options)

options.delete_if do |option|
  choices.include?(option)
end

system "clear"

puts options
STDIN.getch
system "clear"
