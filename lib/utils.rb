# Utilities for the bot
require 'sequel'
Sequel.extension :inflector

# Constants that are useful across the bot
module Constants
  Bot::BOT.ready do
    # Server constant
    SERVER = Bot::BOT.server(541402248807448586)
  end

  # My user ID
  MY_ID = 220509153985167360
end

# Module containing convenience methods (and companion variables/constants) that aren't instance/class methods
module Convenience
  module_function

  # Rudimentary pluralize; returns pluralized str with added 's' only if the given int is not 1
  # @param  [Integer] int the integer to test
  # @param  [String]  str the string to pluralize
  # @return [String]  singular form (i.e. 1 squid) if int is 1, plural form (8 squids) otherwise
  def plural(int, str)
    return "#{int} #{str.pluralize}" unless int == 1
    "#{int} #{str.singularize}"
  end
  alias_method(:pl, :plural)
end

# Server class from discordrb
class Discordrb::Server
  # Gets a member from a given string, either user ID, user mention, distinct (username#discrim),
  # nickname, or username on the given server; options earlier in the list take precedence (i.e.
  # someone with the username GeneticallyEngineeredInklings will be retrieved over a member
  # with that as a nickname) and in the case of nicknames and usernames, it checks for the beginning
  # of the name (i.e. the full username or nickname is not required)
  # @param  str [String]            the string to match to a member
  # @return     [Discordrb::Member] the member that matches the string, as detailed above; or nil if none found
  def get_user(str)
    return self.member(str.scan(/\d/).join.to_i) if self.member(str.scan(/\d/).join.to_i)
    members = self.members
    members.find { |m| m.distinct.downcase == str.downcase } ||
    members.find { |m| str.size >= 3 && m.display_name.downcase.start_with?(str.downcase) } ||
    members.find { |m| str.size >= 3 && m.name.downcase.start_with?(str.downcase) } ||
    members.find { |m| str.size >= 3 && m.display_name.downcase.include?(str.downcase) } ||
    members.find { |m| str.size >= 3 && m.name.downcase.include?(str.downcase) }
  end
end