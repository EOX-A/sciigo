#!/usr/bin/env rake

require 'fileutils'

task :default => [ :test ]
task :test => [ :spinach ]

desc "Setup sciigo for deployment"
task :setup => [ 'setup:config' ]

namespace :setup do
  
  desc "Copy sample configuration file"
  task :config do
    ['sciigo'].each do |file|
      config = File.join(File.dirname(__FILE__), "config", "#{file}.yml")
      FileUtils.cp(config.to_s.gsub(".yml", ".yml.example"), config) unless File.exists?(config)
    end
  end
end

desc "Run tests"
task :spinach do
  exec "bundle exec spinach"
end