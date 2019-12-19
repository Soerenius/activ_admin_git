class CreateDocuments < ActiveRecord::Migration[6.0]
  def change
    create_table :documents, id: false do |t|
      t.string :guid
      t.string :name
      t.string :versiondate
      t.string :versionid
      t.string :description

      t.timestamps
    end
    execute "ALTER TABLE documents ADD PRIMARY KEY (guid);"

  end
end
