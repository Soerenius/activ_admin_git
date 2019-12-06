class CreateRelationships < ActiveRecord::Migration[6.0]
  def change
    create_table :relationships, id: false do |t|
      t.string :guid

      t.timestamps
    end
    execute "ALTER TABLE relationships ADD PRIMARY KEY (guid);"
  end
end
