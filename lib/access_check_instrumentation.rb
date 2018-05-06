module ConsoleAccessCheck
  mattr_accessor :application_name

  module AccessCheckInstrumentation
    def username
      Etc.getlogin
    end
  end
end