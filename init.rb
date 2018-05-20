# frozen_string_literal: true

require "console_access_check/railtie"

ConsoleAccessCheck::Railtie.insert if defined? Rails::Console
