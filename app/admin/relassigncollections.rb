ActiveAdmin.register Relassigncollection do
  permit_params :guid, :guid_relobject, :guid_relcollection, :created_at, :updated_at

  actions :all, :except => [:new, :edit]
  #menu false 
  menu label: "Zugeord. Fachobjekte" 

  filter :object_table_root_table_name, as: :string, filters: [:contains, :starts_with, :equals, :ends_with], label: 'Fachobjekt'#, :collection =>  RootTable.find(:guid_relroot) 
  filter :collection_root_table_name, as: :string, filters: [:contains, :starts_with, :equals, :ends_with], label: 'Gruppe'#, :collection =>  RootTable.find(:guid_relroot) 


  index :title => "Zugeord. Fachobjekte" do
    #column "guid", :guid
    column "Fachobjekt" do |r| #, sortable: 'object_tables.root_tables.name'
      RootTable.find(r.guid_relobject)
    end
    column "Gruppe" do |m|#, :collection , sortable: 'object_tables.root_tables.name'
      RootTable.find(m.guid_relcollection)
    end
    column :created_at
    column :updated_at
    actions
  end

  controller do
    def scoped_collection
      super.includes(:object_table) # prevents N+1 queries to your database

      #super.includes(:root_table) # prevents N+1 queries to your database
    end
  end
end
