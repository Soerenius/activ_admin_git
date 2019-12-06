#Rails.application.config.active_record.belongs_to_required_by_default = false
class ObjectTable < ApplicationRecord
    self.primary_key='guid'
    belongs_to :root_table, :optional => true
    #has_and_belongs_to_many :collections, :optional => true
    #has_one :relassigncollection, autosave: true, foreign_key: 'guid_relobject', dependent: :destroy    
    #has_and_belongs_to_many :collections, autosave: true, join_table: "relassigncollections", 
    #association_foreign_key: "guid_relcollection", foreign_key: "guid_relobject", 
    #:delete_sql => "'DELETE FROM relassigncollections WHERE guid_relcollection='82fead4f-0bc6-4467-b15f-2f1590c6c1c4'"
    has_many :collections, through: "relassigncollections"
    has_many :relassigncollections, foreign_key: 'guid_relobject', dependent: :delete_all, autosave: true
    #before_destroy {collections.clear}
    #before_destroy do
    #  collections.each { |collection| collection.destroy }
    #end
end

#, primary_key: 'guid'