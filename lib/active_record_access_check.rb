module ConsoleAccessCheck
  mattr_accessor :application_name

  module ActiveRecordInstrumentation
    include AccessCheckInstrumentation

    ALLOWED_USERS = ['sofia']

    def self.included(instrumented_class)
      instrumented_class.class_eval do
        unless method_defined?(:old_exec_query)
          alias_method :old_exec_query, :exec_query

          def exec_query(sql, name = "SQL", binds = [])
            unless defined?(Rails::Console)
              return old_exec_query(sql, name, binds)
            end

            unless ALLOWED_USERS.include?(username)
              Rails.logger.error("Dodgy user=#{username}")
              raise ::ConsoleAccessCheck::PermissionsError
            end
            old_exec_query(sql, name, binds)
          end
        end
      end
    end

  end
end