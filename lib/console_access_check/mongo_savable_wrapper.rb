# frozen_string_literal: true

module ConsoleAccessCheck

  module MongoSavableWrapper

    def self.included(instrumented_class)
      instrumented_class.class_eval do
        unless method_defined?(:old_save)
          alias_method :old_save, :save

          def save(options = {})
            ::ConsoleAccessCheck::UserPermissionsChecker.check_permissions!([self.class.to_s])
            old_save(options)
          end
        end
      end
    end

  end

end