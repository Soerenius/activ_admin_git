class CreateCollection1s < ActiveRecord::Migration[6.0]
  def change
    create_table :collection1s do |t|
      t.string :collection1s

      t.timestamps
    end
  end
end
