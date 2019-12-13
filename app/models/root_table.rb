class RootTable < ApplicationRecord
    self.primary_key='guid'
    has_one :object_table, autosave: true, foreign_key: 'guid', dependent: :destroy
    has_one :externaldocument, autosave: true, foreign_key: 'guid', dependent: :destroy
    has_one :collection, autosave: true, foreign_key: 'guid', dependent: :destroy
    has_one :relationship, autosave: true, foreign_key: 'guid', dependent: :destroy
    #after_save :update_object
    has_one :art, autosave: true, foreign_key: 'id', dependent: :destroy
    has_one :collection1, foreign_key: 'id'
    has_one :externaldocument1, foreign_key: 'id'
    has_many :externaldocuments, through: "reldocuments"
    has_many :reldocuments, foreign_key: 'guid_relroot', primary_key: 'guid', dependent: :delete_all, autosave: true


    def to_s
        self.name
    end
    

    #def update_object
    #    if params[:root_table][:art].Value == 'Fachobjekt'
    #      ObjectTable.create(:guid => self.guid)
       # elsif params[:root_table][:art] == 'Gruppe'
       # elsif params[:root_table][:art] == 'Externes Dokument'
    #   end
    #end
end
