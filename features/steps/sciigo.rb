class Spinach::Features::Sciigo < Spinach::FeatureSteps
  step 'I have included the sciigo module' do
    # the module is automatically included in support/env.rb
    return true
  end

  step 'I ask for the configuration directory' do
    @conf_dir = Sciigo.conf_dir
  end

  step 'I should get File.expand_path(\'../config/\')' do
    @conf_dir == File.expand_path('../config')
  end

  step 'I ask for the configuration data' do
    @config = Sciigo.config
  end

  step 'I should get a Hash' do
    expect(@config).to be_an_instance_of(Hash)
  end

  step 'it should include a log key' do
    expect(@config).to have_key('log')
  end

  step 'this hash should include a vars key' do
    expect(@config).to have_key('vars')
  end

  step 'I ask for the logger' do
    @log = Sciigo.log
  end

  step 'I should get a object which responds to the log method' do
    expect(@log).to be_an_instance_of(Logger)
  end
end