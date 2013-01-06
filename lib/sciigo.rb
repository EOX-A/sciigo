require 'yaml'
require 'logger'

module Sciigo
  @@config = ::YAML.load_file('config/sciigo.yml')
  @@logger = nil

  def self.config
    @@config
  end

  def self.log
    unless @@logger
      @@logger = Logger.new(@@config['log']['file'], @@config['log']['keep'], @@config['log']['size'])
      @@logger.level = Logger.const_get @@config['log']['level']
      @@logger.progname = "sciigo"
    end
    @@logger
  end

  class Error < StandardError
  end
end

# => Dir["#{Rails.root}/features/steps/shared/*.rb"].each {|file| require file}