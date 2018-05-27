# frozen_string_literal: true

module ConsoleAccessCheck
  # Overrides AR execute method
  module ActiveRecordWrapper
    def self.included(instrumented_class)
      instrumented_class.class_eval do
        if instrumented_class.method_defined?(:execute)
          unless method_defined?(:old_execute)
            alias_method :old_execute, :execute
            def execute(sql, name = nil)
              sql_query_parser = ConsoleAccessCheck::SqlQueryParser.new(sql)
              unless sql_query_parser.tables.empty?
                ::ConsoleAccessCheck::UserPermissionsChecker
                  .check_permissions!(sql_query_parser.tables, sql_query_parser.operation)
              end

              old_execute(sql, name)
            end
          end
        end

        if instrumented_class.method_defined?(:exec_query)
          unless method_defined?(:old_exec_query)
            alias_method :old_exec_query, :exec_query

            def exec_query(sql, name = "SQL", binds = [])
              sql_query_parser = ConsoleAccessCheck::SqlQueryParser.new(sql)
              unless sql_query_parser.tables.empty?
                ::ConsoleAccessCheck::UserPermissionsChecker
                    .check_permissions!(sql_query_parser.tables, sql_query_parser.operation)
              end
              old_exec_query(sql, name, binds)
            end
          end
        end

        is_postgres = defined?(ActiveRecord::ConnectionAdapters::PostgreSQLAdapter) &&
            ActiveRecord::ConnectionAdapters::PostgreSQLAdapter == instrumented_class
        # Instrument exec_delete and exec_update on AR 3.2+, since they don't
        # call execute internally
        if is_postgres && ActiveRecord::VERSION::STRING > "3.1"
          if instrumented_class.method_defined?(:exec_delete)
            alias_method :old_exec_delete, :exec_delete

            def exec_delete(sql, name = "SQL", binds = [])
              sql_query_parser = ConsoleAccessCheck::SqlQueryParser.new(sql)
              unless sql_query_parser.tables.empty?
                ::ConsoleAccessCheck::UserPermissionsChecker
                    .check_permissions!(sql_query_parser.tables, sql_query_parser.operation)
              end
              old_exec_delete(sql, name, binds)
            end
          end
          if instrumented_class.method_defined?(:exec_update)
            alias_method :old_exec_update, :exec_update

            def exec_update(sql, name = "SQL", binds = [])
              sql_query_parser = ConsoleAccessCheck::SqlQueryParser.new(sql)
              unless sql_query_parser.tables.empty?
                ::ConsoleAccessCheck::UserPermissionsChecker
                    .check_permissions!(sql_query_parser.tables, sql_query_parser.operation)
              end
              old_exec_update(sql, name, binds)
            end
          end
        end
      end
    end
  end
end
