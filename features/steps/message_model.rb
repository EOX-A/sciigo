class Spinach::Features::MessageModel < Spinach::FeatureSteps
  include CommonSteps::Nagios

  step 'I create a new instance of the message class' do
    @message = Sciigo::Message.new(Sciigo::Nagios.new)
  end

  step 'basic attributes should be set' do
    raise StandardError unless @message.recipient == '87R9L4ydcGt1INISKSzB5ZtoBzohVt:six'
    raise StandardError unless @message.time > Time.now-60
  end
end
