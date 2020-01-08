class Foldobject < ApplicationRecord
    self.primary_key='guid'
    self.table_name='root_tables'
    has_many :reldocuments, foreign_key: 'guid_relroot', primary_key: 'guid', autosave: true, dependent: :delete_all
    has_many :relcollects, foreign_key: 'guid_relroot', primary_key: 'guid', autosave: true, dependent: :delete_all

    def name
        return RootTable.name
    end
end

