module ConsoleAccessCheck
  mattr_accessor :application_name

  module ActiveRecordWrapper
    include UserPermissionsInstrumentation

    def self.included(instrumented_class)
      instrumented_class.class_eval do
        unless method_defined?(:old_exec_query)
          alias_method :old_exec_query, :exec_query

          def exec_query(sql, name = "SQL", binds = [])
            unless defined?(Rails::Console)
              return old_exec_query(sql, name, binds)
            end

            check_permissions!
            old_exec_query(sql, name, binds)
          end
        end
      end
    end

  end
end