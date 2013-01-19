class Spinach::Features::Nagios < Spinach::FeatureSteps
  step 'I have a basic set of environment variables' do
    @env = {
      'NAGIOS_CONTACTEMAIL'     => 'mailto://marko.locher@eox.at', 
      'NAGIOS_CONTACTALIAS'     => 'Marko Locher',
      'NAGIOS_SERVICEDESC'      => 'Sciigo Tests',
      'SOME_OTHER_VARIABLE'     => 'some other value',
      'NAGIOS_NOTIFICATIONTYPE' => 'PROBLEM'
    }
    ENV.update(@env)
  end

  step 'I want a host notification' do
    ENV.keep_if { |name, value|
      name != 'NAGIOS_SERVICEDESC'
    }
  end

  step 'I want a service notification' do
    @env.merge!({
      'NAGIOS_SERVICEDESC'  => 'Sciigo Tests',
    }) unless @env.has_key? 'NAGIOS_SERVICEDESC'
  end

  step 'I have a non Nagios environment' do
    ENV.keep_if { |name, value|
      !name.start_with?('NAGIOS_')
    }
  end

  step 'I instantiate a new Sciigo::Nagios object' do
    begin
      @nagios = Sciigo::Nagios.new
    rescue Sciigo::Error => e
      @error = e
    end
  end

  step 'I should get a Hash(like) object' do
    expect(@nagios).to be_a_kind_of(Hash)
  end

  step 'it should contain the Nagios variables' do
    expect(@nagios).to have_key(:contactemail)
    expect(@nagios).to have_key(:contactalias)
  end

  step 'it should not contain non Nagios variables' do
    expect(@nagios).to_not have_key(:some_other_variable)
  end

  step 'I should get an Sciigo::Error' do
    #TODO not a good way to check for exceptions
    expect(@error).to be_an_instance_of(Sciigo::Error)
  end

  step 'it should respond to the transport method' do
    expect(@nagios).to have_key(:transport)
  end

  step 'the transport should be the email up to the first colon' do
    expect(@nagios.transport).to eq('mailto')
  end

  step 'the contactemail should not start with the transport' do
    expect(@nagios.contactemail).to_not start_with('mailto')
  end

  step 'I should be able to access the variables with []' do
    expect(@nagios['CONTACTEMAIL']).to eq('marko.locher@eox.at')
  end

  step 'with the variables name as method name' do
    expect(@nagios.contactemail).to eq('marko.locher@eox.at')
  end

  step 'via the fetch method' do
    expect(@nagios.fetch(:contactemail)).to eq('marko.locher@eox.at')
  end

  step 'the case of a key should not matter' do
    expect(@nagios['CONTACTEMAIL']).to eq(@nagios['contactemail'])
  end

  step 'the category method should respond with :host' do
    expect(@nagios.category).to eq(:host)
  end

  step 'the host method should return true' do
    expect(@nagios.host?).to be_true  
  end

  step 'the category method should respond with :service' do
    expect(@nagios.category).to eq(:service)
  end

  step 'the service method should return true' do
    expect(@nagios.service?).to be_true
  end

  step 'the type method should respond with one of serveral notification types' do
    #"PROBLEM", "RECOVERY", "ACKNOWLEDGEMENT", "FLAPPINGSTART", "FLAPPINGSTOP", "FLAPPINGDISABLED", "DOWNTIMESTART", "DOWNTIMEEND", or "DOWNTIMECANCELLED"
    # taken from http://nagios.sourceforge.net/docs/3_0/macrolist.html#notificationtype
    expect([:problem, :recovery, :acknowledgement, :flappingstart, :flappingstop, :flappingdisabled, :downtimestart, :downtimeend, :downtimecancelled]).to include(@nagios.type)
  end
end