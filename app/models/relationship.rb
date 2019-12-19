class Relationship < ApplicationRecord
    self.primary_key='guid'
    has_one :relassigncollection, autosave: true, foreign_key: 'guid', dependent: :destroy
    has_one :reldocument, autosave: true, foreign_key: 'guid', dependent: :destroy
    has_one :relcollect, foreign_key: 'guid', dependent: :destroy #, autosave: true
    

    belongs_to :root_table, :optional => true, dependent: :destroy

    def to_s
        self.guid
    end    
end
