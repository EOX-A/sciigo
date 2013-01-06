require './lib/sciigo.rb'
Dir['./lib/**/*.rb'].each { |file| require file }

class Spinach::Features::MessageModel < Spinach::FeatureSteps
  include CommonSteps::Nagios

  step 'I create a new instance of the message class' do
    @message = Sciigo::Message.new
  end

  step 'basic attributes should be set' do
    raise StandardError unless @message.to == '87R9L4ydcGt1INISKSzB5ZtoBzohVt:six'
    raise StandardError unless @message.content == ''
    raise StandardError unless @message.title == ''
    raise StandardError unless @message.time > Time.now-60
  end
end
