require 'rdl'

module Twitter
  module Streaming
    class Event
      extend RDL::Annotate
      var_type :@name, 'Symbol'
      var_type :@source, 'Twitter::User'
      var_type :@target, 'Twitter::User'
      var_type :@target_object, 'Twitter::List or Twitter::Tweet'

      LIST_EVENTS = %i[
        list_created list_destroyed list_updated list_member_added
        list_member_added list_member_removed list_user_subscribed
        list_user_subscribed list_user_unsubscribed list_user_unsubscribed
      ].freeze

      TWEET_EVENTS = %i[
        favorite unfavorite quoted_tweet
      ].freeze

      attr_reader :name, :source, :target, :target_object

      # @param data [Hash]
      def initialize(data)
        @name = RDL.type_cast(data[:event], 'String').to_sym
        @source = Twitter::User.new(RDL.type_cast(data[:source], 'String'))
        @target = Twitter::User.new(RDL.type_cast(data[:target], 'String'))
        @target_object = target_object_factory(@name, RDL.type_cast(data[:target_object], 'Hash<String, String>'))
      end

    private

      def target_object_factory(event_name, data)
        if LIST_EVENTS.include?(event_name)
          Twitter::List.new(data)
        elsif TWEET_EVENTS.include?(event_name)
          Twitter::Tweet.new(data)
        end
      end
    end
  end
end
