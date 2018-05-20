# frozen_string_literal: true

module ConsoleAccessCheck
  # Holds the gem configuration
  class Configuration
    attr_accessor :sensitive_tables, :user_permissions_model, :raise_error

    def initialize
      @sensitive_tables = nil
      @user_permissions_model = nil
      @raise_error = nil
    end
  end
end
