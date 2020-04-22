# frozen_string_literal: true
class Info < ApplicationRecord
  self.table_name = "info"
  belongs_to :group
end
