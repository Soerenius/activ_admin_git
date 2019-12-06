ActiveAdmin.register Foldobject, as: 'Object' do
  permit_params :guid, :name, :versiondate, :versionid, :description, :created_at, :updated_at

  menu label: "Klasse" 

  index :title => "Klasse" do
    column :guid
    column :name
    column :versiondate
    column :versionid
    column :description
    column :created_at
    column :updated_at
    actions
  end  

  form do |f|

    if object.id == nil
      $uuid=SecureRandom.uuid 
    else
      $uuid=RootTable.find(object.id).guid
    end

    f.object.guid = $uuid 
    f.object.versiondate = DateTime.now
    f.object.versionid = RootTable.maximum("versionid")
    f.object.created_at = DateTime.now
    f.object.updated_at = DateTime.now
    f.inputs do
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
    
    def scoped_collection
      RootTable.joins(:object_table).where("root_tables.guid=object_tables.guid")
    end

    after_save :update_object
  
    def update_object(guid)
      ObjectTable.create(:guid => $uuid)
    end
    
  end  

end
