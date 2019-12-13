ActiveAdmin.register Collection do
  permit_params :guid

  #menu label: "Development_group"
  menu false 

  index :title => "Development_group" do
    column :guid
    column :created_at
    column :updated_at
    actions
  end
end
