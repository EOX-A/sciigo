require 'rspec'

# require the application files
require '#{File.dirname(__FILE__)}/../../lib/sciigo.rb'
Dir['#{File.dirname(__FILE__)}/../../lib/**/*.rb'].each { |file| 
  require file 
}

# require all the files in the steps/common_steps directory (where this file is located)
Dir.glob("#{File.dirname(__FILE__)}/../steps/common_steps/**/*.rb").each { |file|
  require file
}