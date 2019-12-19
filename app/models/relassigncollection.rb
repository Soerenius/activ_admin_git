class Relassigncollection < ApplicationRecord
    self.primary_key='guid'
    belongs_to :object_table, :optional => true, foreign_key: 'guid_relobject'
    belongs_to :collection, :optional => true, foreign_key: 'guid_relcollection'
    belongs_to :relationship, :optional => true, dependent: :destroy
end

#, :foreign_key => :guid_relobject
#, :foreign_key => :guid_relcollection
#, :optional => true
