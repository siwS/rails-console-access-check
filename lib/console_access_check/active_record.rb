module ConsoleAccessCheck
  mattr_accessor :application_name

  module ActiveRecordWrapper

    def self.included(instrumented_class)
      instrumented_class.class_eval do
        if instrumented_class.method_defined?(:execute)
          unless method_defined?(:old_execute)
            alias_method :old_execute, :execute

            def execute(sql, name = nil)
              current_models = parse_query_tables_manually(sql)
              ::ConsoleAccessCheck::UserPermissionsChecker.check_permissions!(current_models) unless current_models.empty?

              old_execute(sql, name)
            end
          end
        end
      end
    end

    def parse_query_tables_manually(sql_query)
      res = sql_query.delete("`").split(" ")
      Rails.logger.info(res)

      sql_tables = []
      res.each_with_index do |a, i|
        sql_tables << res[i + 1] if from_join_update_or_into?(a)
      end
      sql_tables.uniq
    end

    def from_join_update_or_into?(str)
      str.casecmp("FROM").zero? || str.casecmp("JOIN").zero? || str.casecmp("UPDATE").zero? || str.casecmp("INTO").zero?
    end
  end
end