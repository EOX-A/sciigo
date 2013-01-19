class Spinach::Features::Message < Spinach::FeatureSteps
  step 'I have a full set of environment variables' do
    @env = {
      'NAGIOS_CONTACTEMAIL'     => 'mailto://marko.locher@eox.at', 
      'NAGIOS_CONTACTALIAS'     => 'Marko Locher',
      'NAGIOS_SERVICEDESC'      => 'Sciigo Tests',
      'SOME_OTHER_VARIABLE'     => 'some other value',
      'NAGIOS_NOTIFICATIONTYPE' => 'PROBLEM'
    }
    ENV.update(@env)
  end

  step 'I instantiate a new Sciigo::Nagios object' do
    @nagios = Sciigo::Nagios.new
  end

  step 'I create a new Sciigo::Message object' do
    @message = Sciigo::Message.new(@nagios)
  end

  step 'it should have the recipient set' do
    expect(@message.recipient).to eq @env['NAGIOS_CONTACTEMAIL'].sub(/\w+:\/\//, '')
  end

  step 'it should have a message set' do
    expect(@message.message).to_not be nil
  end

  step 'it should have a priority' do
    # should be either true or false
    expect(@message.priority).to_not be nil
  end

  step 'it should have a url' do
    expect(@message.url).to match /https?:\/\//
  end
end