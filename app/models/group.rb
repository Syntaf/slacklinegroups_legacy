class Group < ApplicationRecord
    has_one :info, :dependent => :destroy
    has_one :location, :dependent => :destroy
    accepts_nested_attributes_for :info, :allow_destroy => true
    accepts_nested_attributes_for :location, :allow_destroy => true
end
