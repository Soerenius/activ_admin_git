class Reldocument < ApplicationRecord
    self.primary_key='guid'
    belongs_to :externaldocument, :optional => true, foreign_key: 'guid_reldocument'
    belongs_to :root_table, :optional => true, foreign_key: 'guid_relroot'
    belongs_to :foldobject, :optional => true, foreign_key: 'guid_relroot'
    belongs_to :relationship, :optional => true, dependent: :destroy
    #includes :root_table

end
