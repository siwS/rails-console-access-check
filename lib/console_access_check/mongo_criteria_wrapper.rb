# frozen_string_literal: true

module ConsoleAccessCheck

  module MongoCriteriaWrapper

    def self.included(instrumented_class)
      instrumented_class.class_eval do
        unless method_defined?(:old_where)
          alias_method :old_where, :where

          def where(expression)
            ::ConsoleAccessCheck::UserPermissionsChecker.check_permissions!([model_name.name])
            old_where(expression)
          end
        end
      end
    end

  end
end
