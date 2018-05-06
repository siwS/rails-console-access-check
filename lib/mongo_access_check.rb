module ConsoleAccessCheck
  mattr_accessor :application_name

  module MongoPermissionsInstrumentation

    include AccessCheckInstrumentation

    ALLOWED_USERS = ['notsofia']

    def self.included(instrumented_class)
      instrumented_class.class_eval do
        unless method_defined?(:old_where)
          alias_method :old_where, :where

          def where(expression)
            unless defined?(Rails::Console)
              return old_where(sql, name, binds)
            end

            unless ALLOWED_USERS.include?(username)
              Rails.logger.error("Dodgy user=#{username}")
              raise ::ConsoleAccessCheck::PermissionsError
            end
            old_where(expression)
          end
        end
      end
    end

  end
end