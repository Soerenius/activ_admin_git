class CreateReldocuments < ActiveRecord::Migration[6.0]
  def change
    create_table :reldocuments, id: false do |t|
      t.string :guid
      t.string :guid_reldocument
      t.string :guid_relroot

      t.timestamps
    end
    execute "ALTER TABLE reldocuments ADD PRIMARY KEY (guid);"
    add_foreign_key :reldocuments, :root_tables, column: :guid_relroot, primary_key: "guid"
    add_foreign_key :reldocuments, :externaldocuments, column: :guid_reldocument, primary_key: "guid"
  end
end
