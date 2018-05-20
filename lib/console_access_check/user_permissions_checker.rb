module ConsoleAccessCheck

  module UserPermissionsChecker

    def self.check_permissions!(current_models)
      sensitive_models_accessed = ::ConsoleAccessCheck.configuration.sensitive_models & current_models
      return if sensitive_models_accessed.empty?

      sensitive_models_accessed.each do |model|
        Rails.logger.info("User accessed sensitive models username=#{username} model=#{model}")
      end
    end

    def self.username
      Etc.getlogin
    end

  end
end