#!/usr/bin/env ruby

# Simple environment variable based configuration for now

class Settings
    attr_accessor :GROUPME_BOT_ID, :GROUPME_API_V3_ENDPOINT, :REQUEST_TIMEOUT
    
    def initialize
        @GROUPME_BOT_ID             = ENV['GROUPME_BOT_ID']
        @GROUPME_API_V3_ENDPOINT    = 'api.groupme.com' if ENV['GROUPME_API_ENDPOINT'].nil? || ENV['GROUPME_API_ENDPOINT'].empty?
        @REQUEST_TIMEOUT            = 3 if ENV['GROUPME_TIMEOUT'].nil? || ENV['GROUPME_TIMEOUT'].empty?
    end
end
