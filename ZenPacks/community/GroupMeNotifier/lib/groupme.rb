#!/usr/bin/env ruby

# GroupMe API

require 'net/http'
require 'net/https'
require 'json'
require 'time'
require 'uri'
require File.join File.dirname(__FILE__), 'settings'

class GroupMeEvent
    # Simple class for sending Zenoss events to GroupMe

    @device = nil
    @info = nil
    @component = nil
    @severity = nil
    @url = nil
    @message = nil
    @cleared_by = nil
    @clear = nil
    @time = nil
    @config = nil
    @http = nil
    @uri = nil

    def initialize(object)
        # Setup session and properties
        @config = Settings.new
        @device = object[:device]
        @info = object[:info]
        @component = object[:component]
        @severity = object[:severity]
        @url = object[:url]
        @message = object[:message]
        @cleared_by = object[:'cleared-by']
        @clear = object[:clear]
        @time = Time.now.iso8601
        
        # Setup session
        @uri = URI.parse("https://#{@config.GROUPME_API_V3_ENDPOINT}/v3/bots/post")
        @http = Net::HTTP.new(@uri.host, @uri.port)
        @http.use_ssl = true
        @http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        @http.read_timeout = @config.REQUEST_TIMEOUT
    end

    def GroupMeEventSendException(object)
        # Exception if the send failed
        object
    end  

    def _event_message
        # Return templated event notification
        "#{@device}: #{@info}\n" \
        "Component: #{@component}\n" \
        "Severity: #{@severity}\n" \
        "Time: #{@time}\n" \
        "Message: #{@message}"
    end

    def _clear_message
        # Return templated clear notification
        "Cleared!\n" \
        "#{@device}: #{@info}\n" \
        "Cleared By: #{@cleared_by}\n" \
        "Component: #{@component}\n" \
        "Severity: #{@severity}\n" \
        "Time: #{@time}\n" \
        "Message: #{@message}"
    end

    def send
        # Send off the message to environment room with a nice template
        if !@clear
            message = _event_message
        else
            message = _clear_message
        end

        request = Net::HTTP::Post.new(@uri.request_uri, initheader = {'Content-Type' => 'application/json'})
        request.body = {
            'bot_id' => @config.GROUPME_BOT_ID,
            'text'   => message
        }.to_json
        response = @http.request(request)

        if response.code != '202'
            raise GroupMeEventSendException(response.body)
        end
    end
end
