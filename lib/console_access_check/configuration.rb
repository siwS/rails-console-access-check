# frozen_string_literal: true

module ConsoleAccessCheck
  # Holds the gem configuration
  class Configuration
    attr_accessor :sensitive_tables_model, :user_permissions_model, :use_group_access, :raise_error,
                  :log_to_db, :logging_table

    def initialize
      @sensitive_tables_model = nil
      @user_permissions_model = nil
      @raise_error = nil
      @use_group_access = nil
      @log_to_db = nil
      @logging_table = nil
    end
  end
end
