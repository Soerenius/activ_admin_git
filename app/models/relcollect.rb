class Relcollect < ApplicationRecord
    self.primary_key='guid'
    belongs_to :collection, :optional => true, foreign_key: 'guid_relcollection'
    belongs_to :root_table, :optional => true, foreign_key: 'guid_relroot'
    belongs_to :relationship, :optional => true, foreign_key: 'guid', dependent: :destroy
    accepts_nested_attributes_for :relationship

    def to_s
        self.guid
    end 
end
