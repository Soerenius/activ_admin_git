ActiveAdmin.register Reldocument do
  permit_params :guid, :guid_relroot, :guid_reldocument

  actions :all, :except => [:new, :edit]

  #menu false 
  menu label: "Zugeord. Dokumente" 

  filter :root_table_name, as: :string, filters: [:contains, :starts_with, :equals, :ends_with], label: 'Objekt'#, :collection =>  RootTable.find(:guid_relroot) 
  #filter :document_name, as: :string, filters: [:contains, :starts_with, :equals, :ends_with], label: 'Dokument'#, :collection =>  RootTable.find(:guid_relroot) 
  filter :externaldocument_root_table_name, as: :string, filters: [:contains, :starts_with, :equals, :ends_with], label: 'Dokument'#, :collection =>  RootTable.find(:guid_relroot) 

  scope :joined, :default => true do |reldocuments|
    reldocuments.includes [:root_table]
  end

  index :title => "Zugeord. Dokumente" do
    #column "guid", :guid
    column "Objekt", sortable: 'root_tables.name' do |r|
      RootTable.find(r.guid_relroot)
    end
    column "Dokument", sortable: 'root_tables.name' do |m|#, :collection 
      RootTable.find(m.guid_reldocument)
    end
    column :created_at
    column :updated_at


    actions
  end

  controller do
    def scoped_collection
      end_of_association_chain.includes(:root_table).references(:root_table) # prevents N+1 queries to your database
    end
  end
  
end
