
module Concerns
  class FormFieldSettings
    attr_accessor :field_size, :label_cols, :field_cols

    def initialize(field_size: 'sm', label_cols: '4', field_cols: '8')
      self.field_size = field_size.to_s

      self.label_cols = label_cols.to_s

      self.field_cols = field_cols.to_s
    end
  end
end
