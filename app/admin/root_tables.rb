ActiveAdmin.register RootTable do
  permit_params :guid, :name, :versiondate, :versionid, :description, :created_at, :updated_at
  
  menu label: "Gesamt2"  

  #filter :"subscription_billing_plan_name" , :as => :select, :collection => RootTable.all.map(&:name)  

  filter :object_table_guid_not_null, label: "Fachobjekte", as: :boolean 
  filter :collection_guid_not_null, label: "Gruppen", as: :boolean 
  filter :name, as: :string, filters: [:contains, :starts_with, :equals, :ends_with]
  filter :versiondate, as: :string, filters: [:contains, :starts_with, :equals, :ends_with]
  filter :versionid, as: :string, filters: [:contains, :starts_with, :equals, :ends_with]
  filter :description, as: :string, filters: [:contains, :starts_with, :equals, :ends_with]
  filter :created_at, label: 'created_at', as: :date_range
  filter :updated_at, label: 'updated_at', as: :date_range

  index :title => "Gesamt" do
    #column :guid
    column :name
    column :versiondate
    column :versionid
    column :description
    column :created_at
    column :updated_at
    actions
  end

  form do |f|

    if root_table.id == nil
      $uuid=SecureRandom.uuid 
    else
      $uuid=RootTable.find(root_table.id).guid
    end

    f.object.guid = $uuid 
    f.object.versiondate = DateTime.now
    f.object.versionid = RootTable.maximum("versionid")
    f.object.created_at = DateTime.now
    f.object.updated_at = DateTime.now
    f.inputs do
      #new_record: 'Leave Comment'
      f.select :art, ["Fachobjekt", "Gruppe", "Externes Dokument"], :prompt => 'Bitte wählen! '
      f.input :guid, :input_html => { :readonly => true }
      f.input :name
      f.input :versiondate
      f.input :versionid
      f.input :description
      f.input :created_at
      f.input :updated_at
    end
    f.actions    
  end

  controller do
    
    after_save :update_object
  
    def update_object(guid)
      if params[:root_table][:art] == 'Fachobjekt'
        ObjectTable.create(:guid => $uuid)  
      elsif params[:root_table][:art] == 'Gruppe'
        Collection.create(:guid => $uuid) 
     # elsif params[:root_table][:art] == 'Externes Dokument'
      end
    end
  end  

  #show do 
  #  root_table :guid, :name
  #  active_admin_comments
  #end
end
