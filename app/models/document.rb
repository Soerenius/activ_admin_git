class Document < ApplicationRecord
    self.primary_key='guid'
    self.table_name='root_tables'
end
