class Collection < ApplicationRecord
    self.primary_key='guid'
    belongs_to :root_table, :optional => true
    #has_and_belongs_to_many :object_tables, :optional => true
    #has_and_belongs_to_many :object_tables, autosave: true, join_table: "relassigncollections", 
    #association_foreign_key: "guid_relobject", foreign_key: "guid_relcollection", dependent: :destroy
    has_many :object_tables, through: "relassigncollections"
    has_many :relassigncollections, foreign_key: 'guid_relcollection', primary_key: 'guid', dependent: :delete_all, autosave: true
    #before_destroy {object_tables.clear}
    #before_destroy do
    #  object_tables.each { |object_table| object_table.destroy }
    #end
end
