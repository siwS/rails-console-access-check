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
              current_models = parse_query_tables_manually(sql)
              unless current_models.empty?
                ::ConsoleAccessCheck::UserPermissionsChecker
                  .check_permissions!(current_models)
              end

              old_execute(sql, name)
            end
          end
        end

        if instrumented_class.method_defined?(:exec_query)
          unless method_defined?(:old_exec_query)
            alias_method :old_exec_query, :exec_query

            def exec_query(sql, name = "SQL", binds = [])
              current_models = parse_query_tables_manually(sql)
              unless current_models.empty?
                ::ConsoleAccessCheck::UserPermissionsChecker
                    .check_permissions!(current_models)
              end
              old_exec_query(sql, name, binds)
            end
          end
        end
      end
    end

    def parse_query_tables_manually(sql_query)
      res = sql_query.delete("`").split(" ")

      sql_tables = []
      res.each_with_index do |a, i|
        next unless from_join_update_or_into?(a)
        sql_tables << strip_special_characters(res[i + 1])
      end
      sql_tables.uniq
    end

    def from_join_update_or_into?(str)
      str.casecmp("FROM").zero? || str.casecmp("JOIN").zero? ||
        str.casecmp("UPDATE").zero? || str.casecmp("INTO").zero?
    end

    def strip_special_characters(word)
      word.gsub!(/[^0-9A-Za-z]/, '')
    end
  end
end
