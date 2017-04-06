
# Utility class for searching a number of fields with the same query string
module Concerns
  class SearchFields
    attr_accessor :fields

    attr_accessor :table_name, :match_type

    def initialize(*fields, match: :partial, table: nil)
      self.fields = fields.flatten.map &:to_sym

      self.match_type = match
      self.table_name = table
    end

    def call(value)
      return sql_string, *values(value)
    end

    def set_match(match=:full)
      self.match_type = match

      self
    end

    private

    def sql_string
      fields.map do |field|
        "#{table_prefix}#{field} LIKE ?"
      end * ' OR '
    end

    def values(value)
      [ matcher(value) ] * fields.size
    end

    def matcher(value)
      match_type == :partial ? "%#{value}%" : value.to_s
    end

    def table_prefix
      if table_name.to_s !~ /^\s*$/
        "#{table_name}."
      else
        ''
      end
    end
  end
end
