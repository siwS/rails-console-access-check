
# The module
module ConsoleAccessCheck
  if defined? Rails::Railtie
    require 'rails/railtie'

    class Railtie < Rails::Railtie
      initializer 'console_access_check.insert' do
        if defined?(Rails::Console)
          ActiveSupport.on_load :action_controller do
            ConsoleAccessCheck::Railtie.insert_into_stores
          end
        end
      end
    end
  end

  # Does the tieing i reckon
  class Railtie
    def self.insert
      insert_into_stores
    end

    def self.insert_into_stores
      if defined? ActiveRecord::ConnectionAdapters::Mysql2Adapter
        ActiveRecord::ConnectionAdapters::Mysql2Adapter.module_eval do
          include ConsoleAccessCheck::ActiveRecordWrapper
        end
      end

      if defined? ActiveRecord::ConnectionAdapters::MysqlAdapter
        ActiveRecord::ConnectionAdapters::MysqlAdapter.module_eval do
          include ConsoleAccessCheck::ActiveRecordWrapper
        end
      end

      if defined? ActiveRecord::ConnectionAdapters::PostgreSQLAdapter
        ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.module_eval do
          include ConsoleAccessCheck::ActiveRecordWrapper
        end
      end

      if defined? ActiveRecord::ConnectionAdapters::SQLite3Adapter
        ActiveRecord::ConnectionAdapters::SQLite3Adapter.module_eval do
          include ConsoleAccessCheck::ActiveRecordWrapper
        end
      end

      #if defined? Mongoid::Criteria
      #  Mongoid::Criteria.module_eval do
      #    include ConsoleAccessCheck::MongoDbWrapper
      #  end
      #end
    end
  end
end
