# frozen_string_literal: true

module ConsoleAccessCheck
  # Checks permissions for a user-model combination
  module UserPermissionsChecker
    def self.check_permissions!(current_models, operation)
      return if configuration_models_accessed?(current_models)

      models_accessed = sensitive_models & current_models
      return if models_accessed.nil? || models_accessed.empty?

      operation_type = operation_type(operation)
      models_accessed.each do |model|
        next if user_has_permissions?(username, model, operation_type)
        log_access(username, model, operation)

        next unless raise_error?
        raise ConsoleAccessCheck::PermissionsError
      end
    end

    def self.configuration_models_accessed?(models_accessed)
      models_accessed.include?(::ConsoleAccessCheck.configuration.user_permissions_model.constantize.table_name) ||
        models_accessed.include?(::ConsoleAccessCheck.configuration.sensitive_tables_model.constantize.table_name) ||
        models_accessed.include?("pg_attribute") || models_accessed.include?("pg_attrdef")
    end

    def self.username
      return Etc.getlogin || ENV['USER'] unless ::ConsoleAccessCheck.configuration.use_group_access
      Etc.getgrgid(Etc.getpwuid(Process.uid).gid).name
    end

    def self.user_has_permissions?(username, model, operation_type)
      return false if user_permissions_model.nil?
      user_permissions = user_permissions_model.find_by(username: username, sensitive_model_name: model)
      return false if user_permissions.nil?
      puts operation_type == :read
      puts operation_type == :write

      return user_permissions.allow_read if operation_type == :read
      return user_permissions.allow_write if operation_type == :write
      false
    end

    def self.operation_type(operation)
      return :read if operation == :select
      return :write
    end

    def self.user_permissions_model
      return nil if ::ConsoleAccessCheck.configuration.user_permissions_model.nil?
      Object.const_get(::ConsoleAccessCheck.configuration.user_permissions_model)
    end

    def self.sensitive_models
      return nil if ::ConsoleAccessCheck.configuration.sensitive_tables_model.nil?
      ::ConsoleAccessCheck.configuration.sensitive_tables_model.constantize.all.map { |x| x.name }
    end

    def self.raise_error?
      ::ConsoleAccessCheck.configuration.raise_error
    end

    def self.log_access(username, model, operation)
      Rails.logger.info("User accessed sensitive models username=#{username} model=#{model} operation=#{operation}")
    end
  end
end
