class Collection < ApplicationRecord
    self.primary_key='guid'
    belongs_to :root_table, :optional => true, foreign_key: 'guid'
    has_many :relassigncollections, foreign_key: 'guid_relcollection', primary_key: 'guid', dependent: :delete_all, autosave: true
    has_many :object_tables, through: "relassigncollections"
    has_many :relcollects, foreign_key: 'guid_relcollection', primary_key: 'guid', dependent: :delete_all, autosave: true
    has_many :root_tables, through: "relcollects"
    
    def to_s
        RootTable.find(guid).name
    end   
    
end
