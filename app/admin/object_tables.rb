ActiveAdmin.register ObjectTable do
  permit_params :guid, :name

  menu label: "Development_Object"

  index :title => "Development_Object" do
    column :guid
    #column RootTable.find(:'35562037-49f0-4ef0-87c7-b3bc255aaafd').name
    column :name
    #column RootTable.find_by_sql("SELECT r.name FROM root_tables r INNER JOIN object_tables o ON o.guid=r.guid")
    column :created_at
    column :updated_at
    actions
  end

  #$uname = RootTable.find('35562037-49f0-4ef0-87c7-b3bc255aaafd').name
  #raise $uname.inspect


  form do |f|
    #$uname = RootTable.find('35562037-49f0-4ef0-87c7-b3bc255aaafd').name
    #$uname = "ausi"

    #raise $uname.inspect

    f.object.name = $uname
    f.object.created_at = DateTime.now
    f.object.updated_at = DateTime.now
    f.inputs do
      #new_record: 'Leave Comment'
      f.input :name 
      #f.input RootTable.find('35562037-49f0-4ef0-87c7-b3bc255aaafd').name
      f.input :created_at
      f.input :updated_at
    end
    f.actions    
  end

  controller do
    #$uname = RootTable.find('35562037-49f0-4ef0-87c7-b3bc255aaafd').name
    #object.name = $uname
    #inputs do
    #  input :name
    #end
    #$uname = "ausi"
    #raise $uname.inspect
  end
end
