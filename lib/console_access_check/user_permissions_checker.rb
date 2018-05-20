module ConsoleAccessCheck
  mattr_accessor :application_name

  module UserPermissionsChecker

    ACTIVE_RECORD_SENSITIVE_MODELS = %w[conversations messages comments user_identities].freeze
    MONGO_SENSITIVE_MODELS = %w[External::User].freeze

    def self.check_permissions!(current_models)
      sensitive_models_accessed = (ACTIVE_RECORD_SENSITIVE_MODELS & current_models) + (MONGO_SENSITIVE_MODELS & current_models)
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