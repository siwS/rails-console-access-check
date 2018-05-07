module ConsoleAccessCheck
  mattr_accessor :application_name

  module UserPermissionsInstrumentation
    ALLOWED_USERS = ['notsofia']

    def check_permissions!
      unless ALLOWED_USERS.include?(username)
        Rails.logger.error("Dodgy user=#{username}")
        raise ::ConsoleAccessCheck::PermissionsError
      end
    end

    def username
      Etc.getlogin
    end
  end
end