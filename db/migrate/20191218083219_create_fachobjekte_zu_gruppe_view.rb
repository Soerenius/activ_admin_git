class CreateFachobjekteZuGruppeView < ActiveRecord::Migration[6.0]
  def up
    self.connection.execute %Q( CREATE OR REPLACE VIEW fachobjekte_zu_gruppe_view AS
      SELECT r1.guid as id, r1.name,STRING_AGG (r2.name, ',')
      FROM root_tables r1, root_tables r2, object_tables o, relassigncollections rac, collections c
      WHERE r1.guid=o.guid AND o.guid=rac.guid_relObject AND rac.guid_relCollection=c.guid AND r2.guid=c.guid 
      GROUP BY r1.name,r1.guid;
    )
  end

  def down
    self.connection.execute "DROP VIEW IF EXISTS fachobjekte_zu_gruppe_view;"
  end
end
