class Collection2 < ApplicationRecord
    belongs_to :root_table, :optional => true
end
