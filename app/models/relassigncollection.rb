class Relassigncollection < ApplicationRecord
    self.primary_key='guid'
    belongs_to :object_table, :optional => true
    belongs_to :collection, :optional => true
    belongs_to :relationship, :optional => true
end

#, :foreign_key => :guid_relobject
#, :foreign_key => :guid_relcollection
#, :optional => true
