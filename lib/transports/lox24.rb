require 'digest/md5'
require './lib/transports/http.rb'

module Sciigo
	module Transport
		class Lox24 < Sciigo::Transport::HTTP
			def initialize( message )
				super( message )
			end

			def uri
				config['lox24']['api']
			end

			def setup
				to = data[:user]
				text = "#{data[:title]}\n#{data[:message]}\n#{config['nagios']['url']}"

				data.merge!({ :konto		=> config['lox24']['konto'],
					            :password	=> Digest::MD5.hexdigest(config['lox24']['password']),
					            :service	=> config['lox24']['service'],
					            :from		=> config['lox24']['from'],
					            :to			=> to,
					            :text		=> text,
					            :return		=> 'xml' })

				data.delete_if { | k, v |
					[:user, :title, :message, :priority, :sound, :url, :url_title].include?(k)
				}
			end

			def validate
        raise Sciigo::Transport::ParameterMissing.new if data[:konto].nil? || data[:password].nil? || data[:service].nil? || data[:from].nil? || data[:to].nil? || data[:text].nil? || data[:text].empty?
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