module ConsoleAccessCheck

  module UserPermissionsChecker

    def self.check_permissions!(current_models)
      sensitive_models_accessed = ::ConsoleAccessCheck.configuration
                                      .sensitive_tables & current_models
      return if sensitive_models_accessed.empty?

      sensitive_models_accessed.each do |model|
        next if user_has_permissions?(username, model)
        Rails.logger.info("User accessed sensitive models username=#{username} model=#{model}")

        next unless raise_error?
        raise ConsoleAccessCheck::PermissionsError
      end
    end

    def self.username
      Etc.getlogin
    end

    def self.user_has_permissions?(username, model)
      return true if user_permissions_model.nil?
      user_permissions_model.find_by(username: username, table_name: model) != nil
    end

    def self.user_permissions_model
      return nil if ::ConsoleAccessCheck.configuration.user_permissions_model.nil?
      Object.const_get(::ConsoleAccessCheck.configuration.user_permissions_model)
    end

    def self.raise_error?
      ::ConsoleAccessCheck.configuration.raise_error
    end
  end
end