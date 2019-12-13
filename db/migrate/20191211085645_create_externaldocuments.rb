class CreateExternaldocuments < ActiveRecord::Migration[6.0]
  def change
    create_table :externaldocuments, id: false do |t|
      t.string :guid

      t.timestamps
    end
    execute "ALTER TABLE externaldocuments ADD PRIMARY KEY (guid);"
    add_foreign_key :externaldocuments, :root_tables, column: :guid, primary_key: "guid"
  end
end
