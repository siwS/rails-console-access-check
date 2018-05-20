# frozen_string_literal: true

require "console_access_check/railtie"
require "console_access_check/user_permissions_checker"
require "console_access_check/dynamodb"
require "console_access_check/mongo_savable_wrapper"
require "console_access_check/mongo_destroyable_wrapper"
require "console_access_check/mongo_criteria_wrapper"
require "console_access_check/permissions_error"
require "console_access_check/active_record_wrapper"
require "console_access_check/configuration"

# Main module to be included in application
module ConsoleAccessCheck
  class << self
    attr_accessor :configuration
  end

  def self.configuration # rubocop:disable Lint/DuplicateMethods
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
