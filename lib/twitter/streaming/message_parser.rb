require 'twitter/direct_message'
require 'twitter/streaming/deleted_tweet'
require 'twitter/streaming/event'
require 'twitter/streaming/friend_list'
require 'twitter/streaming/stall_warning'
require 'twitter/tweet'

module Twitter
  module Streaming
    class MessageParser
      def self.parse(data) # rubocop:disable AbcSize, CyclomaticComplexity, MethodLength, PerceivedComplexity
        deleted_tweet_data = RDL.type_cast(data[:delete], 'Hash<Symbol, Hash<Symbol,String>>', force: true)
        if data[:id]
          Tweet.new(data)
        elsif data[:event]
          Event.new(RDL.type_cast(data, '{event: String, source: String, target: String, target_object: Hash<String, String>}', force: true))
        elsif data[:direct_message]
          DirectMessage.new(data[:direct_message])
        elsif data[:friends]
          FriendList.new(RDL.type_cast(data[:friends], 'Array<Integer>', force: true))
        elsif data[:delete] && deleted_tweet_data[:status]
          DeletedTweet.new(deleted_tweet_data[:status])
        elsif data[:warning]
          StallWarning.new(RDL.type_cast(data[:warning], 'Hash<Symbol, String>', force: true))
        end
      end
    end
  end
end
