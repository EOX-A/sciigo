module Sciigo
	module Transport
		class Pushover < Sciigo::Transport::HTTP
			def initialize(config, data)
				super(config, data)
			end

			def uri
				config['pushover']['api']
			end

			def setup
				string, user, device = /([A-Za-z0-9]{30}):?([A-Za-z0-9_-]{1,25})?/.match(data[:user]).to_a
				data[:user] = user
				data[:device] = device if device
				data[:token] = config['pushover']['token']
			end

			def validate
				raise Sciigo::Transport::ParameterMissing.new if data[:token].nil? || data[:user].nil? || data[:message].nil? || data[:message].empty?
			end

			def send
				# prepare pushover specific settings
				setup

				# validate the data hash
				validate

				# send the notification
				post(uri)
			end
		end
	end
end