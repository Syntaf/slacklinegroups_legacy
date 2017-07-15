class Group < ApplicationRecord
    serialize :cords,Array
    self.primary_key = "id"
end
