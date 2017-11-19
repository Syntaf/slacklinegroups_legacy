class Group < ApplicationRecord
    has_one :info
    has_one :location
end
