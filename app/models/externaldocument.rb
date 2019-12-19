class Externaldocument < ApplicationRecord
    self.primary_key='guid'
    belongs_to :root_table, :optional => true, dependent: :destroy, foreign_key: 'guid'
    has_many :root_tables, through: "reldocuments"
    has_many :reldocuments, foreign_key: 'guid_reldocument', primary_key: 'guid', dependent: :delete_all, autosave: true
end
