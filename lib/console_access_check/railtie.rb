# frozen_string_literal: true

# Instruments all the stores
module ConsoleAccessCheck
  if defined? Rails::Railtie
    require "rails/railtie"

    # initializer for console access check gem
    class Railtie < Rails::Railtie
      initializer "console_access_check.insert" do
        if defined?(Rails::Console)
          ActiveSupport.on_load :action_controller do
            ConsoleAccessCheck::Railtie.insert_into_stores
          end
        end
      end
    end
  end

  # Inserts the instrumentations on the stores
  class Railtie
    def self.insert
      insert_into_stores
    end

    def self.insert_into_stores
      insert_into_active_record
      insert_into_mongo_db
    end

    def self.insert_into_active_record
      if defined? ActiveRecord::ConnectionAdapters::Mysql2Adapter
        ActiveRecord::ConnectionAdapters::Mysql2Adapter.module_eval do
          include ConsoleAccessCheck::ActiveRecordWrapper
        end
      end

      if defined? ActiveRecord::ConnectionAdapters::PostgreSQLAdapter
        ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.module_eval do
          include ConsoleAccessCheck::ActiveRecordWrapper
        end
      end

      if defined? ActiveRecord::ConnectionAdapters::SQLite3Adapter # rubocop:disable Style/GuardClause
        ActiveRecord::ConnectionAdapters::SQLite3Adapter.module_eval do
          include ConsoleAccessCheck::ActiveRecordWrapper
        end
      end
    end

    def self.insert_into_mongo_db
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
