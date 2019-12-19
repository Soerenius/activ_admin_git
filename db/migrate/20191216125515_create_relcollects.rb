class CreateRelcollects < ActiveRecord::Migration[6.0]
  def change
    create_table :relcollects, id: false do |t|
      t.string :guid
      t.string :guid_relroot
      t.string :guid_relcollection
      t.string :guid_typecollection

      t.timestamps
    end
    execute "ALTER TABLE relcollects ADD PRIMARY KEY (guid);"
    add_foreign_key :relcollects, :root_tables, column: :guid_relroot, primary_key: "guid"
    add_foreign_key :relcollects, :collections, column: :guid_relcollection, primary_key: "guid"
  end
end
