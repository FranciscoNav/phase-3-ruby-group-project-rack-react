class Expense < ActiveRecord::Base
    belongs_to :trip
end