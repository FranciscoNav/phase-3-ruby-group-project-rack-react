class Trip < ActiveRecord::Base
    has_many :expenses
end