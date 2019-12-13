class Reldocument < ApplicationRecord
    self.primary_key='guid'
    belongs_to :externaldocument, :optional => true
    belongs_to :root_table, :optional => true
    belongs_to :relationship, :optional => true, dependent: :destroy
end
