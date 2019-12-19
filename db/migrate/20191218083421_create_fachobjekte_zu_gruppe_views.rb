class CreateFachobjekteZuGruppeViews < ActiveRecord::Migration[6.0]
  def change
    create_table :fachobjekte_zu_gruppe_views do |t|

      t.timestamps
    end
  end
end
