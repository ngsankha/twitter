require 'rdl'
require 'types/core'
require 'twitter'

# RDL.type Twitter::REST::Tweets, :retweets, '(Integer or String or URI or Twitter::Tweet, ?({ count: Integer, trim_user: %bool or String or Integer } or {})) -> Array<Twitter::Tweet>', wrap: false, typecheck: :never

# RDL.type Twitter::REST::Tweets, :retweeters_of, '(Integer or String or URI or Twitter::Tweet, ?({ count: Integer, trim_user: %bool or String or Integer, ids_only: %bool } or {})) -> Array<Twitter::User or Integer>', wrap: false, typecheck: :never

RDL.var_type Twitter::Streaming::Event, '@name', 'Symbol'
RDL.var_type Twitter::Streaming::Event, '@source', 'Twitter::User'
RDL.var_type Twitter::Streaming::Event, '@target', 'Twitter::User'
RDL.var_type Twitter::Streaming::Event, '@target_object', 'Twitter::List or Twitter::Tweet'
RDL.type     Twitter::User, :initialize, '(String) -> self', wrap: false
RDL.type     Twitter::List, :initialize, '(Hash<String, String>) -> self', wrap: false
RDL.type     Twitter::Tweet, :initialize, '(Hash<String, String>) -> self', wrap: false
RDL.type     Twitter::Tweet, :initialize, '(Hash<Symbol, { status: Hash<Symbol, String> } or Array<Integer> or Hash<Symbol, String> or String or Integer>) -> self', wrap: false
RDL.type     Twitter::DirectMessage, :initialize, '(%any) -> self', wrap: false
RDL.type     Twitter::Streaming::DeletedTweet, :initialize, '(Hash<Symbol, String>) -> self', wrap: false
RDL.type     Twitter::Streaming::StallWarning, :initialize, '(Hash<Symbol, String>) -> self', wrap: false

# Type checked
RDL.type     Twitter::Streaming::Event, :initialize, '({event: String, source: String, target: String, target_object: Hash<String, String>}) -> self', wrap: false, typecheck: :later
RDL.type     Twitter::Streaming::Event, :target_object_factory, '(Symbol, Hash<String, String>) -> Twitter::List or Twitter::Tweet', wrap: false, typecheck: :later
RDL.type     Twitter::Streaming::MessageParser, 'self.parse', '({id: Integer, event: String, direct_message: String, friends: Array<Integer>, delete: {status: Hash<Symbol, String>}, warning: Hash<Symbol, String>}) -> Twitter::Tweet or Twitter::Streaming::Event or Twitter::DirectMessage or Twitter::Streaming::FriendList or Twitter::Streaming::DeletedTweet or Twitter::Streaming::StallWarning', wrap: false, typecheck: :later

start = Time.now
RDL.do_typecheck :later
finish = Time.now
puts(finish - start)
