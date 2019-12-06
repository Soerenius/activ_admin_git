class Relationship < ApplicationRecord
    self.primary_key='guid'
    has_one :relassigncollection, autosave: true, foreign_key: 'guid', dependent: :delete
    belongs_to :root_table, :optional => true
end
