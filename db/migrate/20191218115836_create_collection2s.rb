class CreateCollection2s < ActiveRecord::Migration[6.0]
  def change
    create_table :collection2s do |t|

      t.timestamps
    end
  end
end
