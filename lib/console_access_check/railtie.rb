
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

  # Does the tieing
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

      if defined? Mongoid::Persistable::Savable
        Mongoid::Persistable::Savable.module_eval do
          include ConsoleAccessCheck::MongoSavableWrapper
        end
      end

      if defined? Mongoid::Persistable::Destroyable
        Mongoid::Persistable::Destroyable.module_eval do
          include ConsoleAccessCheck::MongoDestroyableWrapper
        end
      end

      if defined? Mongoid::Criteria # rubocop:disable Style/GuardClause
        Mongoid::Criteria.module_eval do
          include ConsoleAccessCheck::MongoCriteriaWrapper
        end
      end
    end
  end

end
