
# Stores the various field sizes
module Concerns
  class FormFieldSettings
    attr_accessor :field_size, :label_cols, :field_cols

    def initialize(field_size: 'sm', label_cols: '2', field_cols: '7')
      self.field_size = field_size.to_s

      self.label_cols = label_cols.to_s

      self.field_cols = field_cols.to_s
    end
  end
end
