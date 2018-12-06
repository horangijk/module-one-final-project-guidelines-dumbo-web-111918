require_relative 'config/environment'
require 'sinatra/activerecord/rake'

desc 'starts a console'
task :console do
  ActiveRecord::Base.logger = Logger.new(STDOUT)
  Pry.start
end

desc 'starts the app'
task :run do
  system "clear"
  ruby 'bin/run'
  system "clear"
end
