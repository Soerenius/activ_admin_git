class Group < ApplicationRecord
    self.primary_key='guid'
    self.table_name='root_tables'

    def to_s
        self.name
    end  

    def name
        return RootTable.name
    end
    
end
