module ConsoleAccessCheck
  class Configuration
    attr_accessor :sensitive_models

    def initialize
      @sensitive_models = nil
    end
  end
end