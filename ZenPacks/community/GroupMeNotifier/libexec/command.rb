#!/usr/bin/env ruby

# Ruby command to generate GroupMe notification from Zenoss
# events.

require 'rubygems'
require 'thor'
require File.join File.dirname(__FILE__), '/../lib/groupme'
require File.join File.dirname(__FILE__), '/../lib/settings'

class EntryPoint < Thor
    # Entry point to script.

    desc 'BotPostMessage', 'Post a message from a bot'

    # Add required arguments
    class_option :device, :type => :string, :default => nil, :aliases => '-d', :required => true, :desc => 'Device where event occurred'
    class_option :info, :type => :string, :default => nil, :aliases => '-i', :required => true, :desc => 'Short message for event'
    class_option :component, :type => :string, :default => nil, :aliases => '-c', :required => true, :desc => 'Component of device for event'
    class_option :severity, :type => :numeric, :default => nil, :aliases => '-s', :required => true, :desc => 'Severity number from 0-5. See http://community.zenoss.org/docs/DOC-9437#d0e6134'
    class_option :url, :type => :string, :default => nil, :aliases => '-u', :required => true, :desc => 'URL to go to event notificaiton'
    class_option :message, :type => :string, :default => nil, :aliases => '-m', :required => true, :desc => 'Long event message'

    # Optional arguments
    class_option :'cleared-by', :type => :string, :default => nil, :aliases => '-b', :desc => 'What cleared the event (when --clear is set)'
    class_option :clear, :type => :boolean, :default => false, :aliases => '-o', :desc => 'Set if event is being cleared'

    def initialize(*args)
        super

        @config = Settings.new
    end

    def BotPostMessage
        if @config.GROUPME_BOT_ID.nil? || @config.GROUPME_BOT_ID.empty?
            print "Environment variable \"GROUPME_BOT_ID\" must be specified and valid before this command can be run\n"
            exit(-1)
        end
    
        if options[:clear] && !options[:'cleared-by']
            print "--cleared-by is required when using --clear\n"
            exit(-1)
        end

        group_me_event = GroupMeEvent.new(options)
        group_me_event.send
    end

    default_task :BotPostMessage
end

EntryPoint.start
