# frozen_string_literal: true

module ConsoleAccessCheck
  # Overrides MongoID destroy method
  module MongoDestroyableWrapper
    def self.included(instrumented_class)
      instrumented_class.class_eval do
        unless method_defined?(:old_destroy)
          alias_method :old_destroy, :destroy

          def destroy(options = {})
            ::ConsoleAccessCheck::UserPermissionsChecker
              .check_permissions!([self.class.to_s])
            old_destroy(options)
          end
        end
      end
    end
  end
end
