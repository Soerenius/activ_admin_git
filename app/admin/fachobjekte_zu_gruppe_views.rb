ActiveAdmin.register FachobjekteZuGruppeView do

  menu label: "Fachobjektzuordnungen (alternativ)" 


  index :title => "Gruppen zu Fachobjekten" do
    column "Fachobjekt", :name
    column "Gruppen", :string_agg 
    actions
  end
  
end
