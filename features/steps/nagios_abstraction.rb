class Spinach::Features::NagiosAbstraction < Spinach::FeatureSteps
  include CommonSteps::Nagios

  step 'the class should provides wrappers for nagios variables' do
    raise StandardError unless @nagios.servicedesc == "Sciigo Test"
    raise StandardError unless @nagios.contactalias == "Marko Locher"
  end

  step 'I ask it for the notification type' do
    @type = @nagios.type
  end

  step 'the class should respond with the corresponding type' do
    raise StandardError unless [ :problem, :recovery, :acknowledgement, :flappingstart, :flappingstop, :flappingdisabled, :downtimestart, :downtimeend, :downtimecancelled ].include?(@type)
  end

  step 'I ask for the notification category' do
    @category = @nagios.category
  end

  step 'the class should respond with either service or host' do
    raise StandardError unless [ :service, :host ].include?(@category)
  end
end
