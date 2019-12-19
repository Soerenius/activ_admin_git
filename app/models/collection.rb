class Collection < ApplicationRecord
    self.primary_key='guid'
    belongs_to :root_table, :optional => true, foreign_key: 'guid'
    #has_and_belongs_to_many :object_tables, :optional => true
    #has_and_belongs_to_many :object_tables, autosave: true, join_table: "relassigncollections", 
    #association_foreign_key: "guid_relobject", foreign_key: "guid_relcollection", dependent: :destroy
    has_many :relassigncollections, foreign_key: 'guid_relcollection', primary_key: 'guid', dependent: :delete_all, autosave: true
    has_many :object_tables, through: "relassigncollections"
    #before_destroy {object_tables.clear}
    #before_destroy do
    #  object_tables.each { |object_table| object_table.destroy }
    #end
    has_many :relcollects, foreign_key: 'guid_relcollection', primary_key: 'guid', dependent: :delete_all, autosave: true
    has_many :root_tables, through: "relcollects"
    
    def to_s
        #RootTable.joins(:collection).where("root_tables.guid=collections.guid").name
        RootTable.find(guid).name
    end   
    
end
