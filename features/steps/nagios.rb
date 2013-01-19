class Spinach::Features::Nagios < Spinach::FeatureSteps
  step 'I have a basic set of environment variables' do
    @env = {
      'NAGIOS_CONTACTEMAIL' => 'mailto:marko.locher@eox.at', 
      'NAGIOS_CONTACTALIAS' => 'Marko Locher',
      'NAGIOS_SERVICEDESC'  => 'Sciigo Tests',
      'SOME_OTHER_VARIABLE' => 'some other value',
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
    @nagios.is_a?(Hash)
  end

  step 'it should contain the Nagios variables' do
    @nagios.has_key?(:contactemail)
    @nagios.has_key?(:contactalias)
  end

  step 'it should not contain non Nagios variables' do
    !@nagios.has_key?(:some_other_variable)
  end

  step 'I should get an Sciigo::Error' do
    @error.is_a?(Sciigo::Error)
  end

  step 'it should respond to the transport method' do
    @nagios.respond_to? :transport
  end

  step 'the transport should be the email up to the first colon' do
    @nagios.transport == /^(\w+):\/\/(.*)/.match(@env['NAGIOS_CONTACTEMAIL'])
  end

  step 'the contactemail should not start with the transport' do
    !@nagios.contactemail.start_with?(@nagios.transport)
  end

  step 'I should be able to access the variables with []' do
    @nagios['CONTACTEMAIL'] == @env['NAGIOS_CONTACTEMAIL']
  end

  step 'with the variables name as method name' do
    @nagios.contactemail == @env['NAGIOS_CONTACTEMAIL']
  end

  step 'via the fetch method' do
    @nagios.fetch(:contactemail) == @env['NAGIOS_CONTACTEMAIL']
  end

  step 'the case of a key should not matter' do
    @nagios['CONTACTEMAIL'] == @nagios['contactemail']
  end

  step 'the category method should respond with :host' do
    @nagios.category == :host
  end

  step 'the host method should return true' do
    @nagios.host? == true
  end

  step 'the category method should respond with :service' do
    @nagios.category == :service
  end

  step 'the service method should return true' do
    @nagios.service? == true
  end

end