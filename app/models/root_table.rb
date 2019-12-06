class RootTable < ApplicationRecord
    self.primary_key='guid'
    has_one :object_table, autosave: true, foreign_key: 'guid', dependent: :destroy
    has_one :collection, autosave: true, foreign_key: 'guid', dependent: :destroy
    has_one :relationship, autosave: true, foreign_key: 'guid', dependent: :destroy
    #after_save :update_object
    has_one :art, foreign_key: 'id'
    

    #def update_object
    #    if params[:root_table][:art].Value == 'Fachobjekt'
    #      ObjectTable.create(:guid => self.guid)
       # elsif params[:root_table][:art] == 'Gruppe'
       # elsif params[:root_table][:art] == 'Externes Dokument'
    #   end
    #end
end
