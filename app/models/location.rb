class Location < ApplicationRecord
    self.table_name = "location"
    belongs_to :group
end