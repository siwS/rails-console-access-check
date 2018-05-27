# frozen_string_literal: true

module ConsoleAccessCheck
  # Simple parser for SQL queries that calculates the tables
  # involved and the operation used for logging access to particular models
  class SqlQueryParser

    attr_accessor :tables, :operation

    def initialize(sql_query)
      @tables = parse_query_tables(sql_query)
      @operation = parse_operation(sql_query)
    end

    private def parse_query_tables(sql_query)
      res = sql_query.delete("`").split(" ")

      sql_tables = []
      res.each_with_index do |a, i|
        next unless from_join_update_or_into?(a)
        sql_tables << strip_special_characters(res[i + 1])
      end
      sql_tables.uniq
    end

    private def from_join_update_or_into?(str)
      str.casecmp("FROM").zero? || str.casecmp("JOIN").zero? ||
          str.casecmp("UPDATE").zero? || str.casecmp("INTO").zero?
    end

    private def parse_operation(sql_query)
      return :update if sql_query.include? "UPDATE"
      return :delete if sql_query.include? "DELETE"
      return :insert if sql_query.include? "INSERT"
      return :select if sql_query.include? "SELECT"
      :other
    end

    private def strip_special_characters(word)
      word.gsub(/[^\w]/, "")
    end

  end
end