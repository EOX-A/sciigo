class Spinach::Features::Transport < Spinach::FeatureSteps
  step 'I have a BasicTransport' do
    @transport = Sciigo::Transport::BasicTransport.new('')
  end

  step 'I try to use the send method' do
    begin
      @transport.send
    rescue Sciigo::Error => e
      @error = e
    end
  end

  step 'I should get a Sciigo::Transport::Error exception' do
    expect(@error).to be_an_instance_of(Sciigo::Transport::Error)
  end

  step 'I call Sciigo::Transport.new with an empty name' do
    begin
      @transport = Sciigo::Transport.new('', '')
    rescue Sciigo::Error => e
      @error = e
    end
  end

  step 'I have an existing transport\'s name' do
    @transport_name = ['pushover', 'lox24'].sample
  end

  step 'I call Sciigo::Transport.new with this transport name' do
    begin
      @transport = Sciigo::Transport.new(@transport_name.to_sym, '')
    rescue Sciigo::Error => e
      @error = e
    end
  end

  step 'I should get a corresping transport' do
    expect(@transport).to be_a_kind_of(Sciigo::Transport::BasicTransport)
  end

  step 'I have an unknown transport\'s name' do
    @transport_name = 'unknown'
  end

  step 'I should get a Sciigo::Transport::UnknownTransport error' do
    expect(@error).to be_an_instance_of(Sciigo::Transport::UnknownTransport)
  end

end