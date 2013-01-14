require 'rubygems'  if RUBY_VERSION < "1.9"
require 'bundler'
require 'yaml'
require 'logger'

Bundler.require(:default)

module Sciigo
  @@config = nil
  @@conf_dir = nil
  @@logger = nil

  def self.config
    @@config ||= ::YAML.load_file(File.join(self.conf_dir, 'sciigo.yml'))
  end

  def self.conf_dir
    @@conf_dir ||= File.expand_path(File.join(File.dirname(__FILE__), '..', 'config'))
  end

  def self.log
    unless @@logger
      @@logger = Logger.new(Sciigo.config['log']['file'], Sciigo.config['log']['keep'], Sciigo.config['log']['size'])
      @@logger.level = Logger.const_get Sciigo.config['log']['level']
      @@logger.progname = "sciigo"
    end
    @@logger
  end

  class Error < StandardError
  end
end

# require all the files in the lib directory (where this file is located)
Dir["#{File.dirname(__FILE__)}/*.rb"].each { |file|
  require file
}