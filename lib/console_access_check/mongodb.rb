module ConsoleAccessCheck
  mattr_accessor :application_name

  module MongoDbWrapper
    include UserPermissionsInstrumentation

    def self.included(instrumented_class)
      instrumented_class.class_eval do
        unless method_defined?(:old_where)
          alias_method :old_where, :where

          def where(expression)
            check_permissions!
            old_where(expression)
          end
        end
      end
    end

  end
end