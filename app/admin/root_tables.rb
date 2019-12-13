ActiveAdmin.register RootTable, as: 'Gesamt' do
  permit_params :guid, :name, :versiondate, :versionid, :description, :created_at, :updated_at, :gruppen #, :art, :collection1, :externaldocument1
  
  menu label: "Gesamt" 

  #filter :"subscription_billing_plan_name" , :as => :select, :collection => RootTable.all.map(&:name)  

  filter :object_table_guid_not_null, label: "Fachobjekte", as: :boolean 
  filter :collection_guid_not_null, label: "Gruppen", as: :boolean 
  filter :name, as: :string, filters: [:contains, :starts_with, :equals, :ends_with]
  filter :versiondate, as: :string, filters: [:contains, :starts_with, :equals, :ends_with]
  filter :versionid, as: :string, filters: [:contains, :starts_with, :equals, :ends_with]
  filter :description, as: :string, filters: [:contains, :starts_with, :equals, :ends_with]
  filter :created_at, label: 'created_at', as: :date_range
  filter :updated_at, label: 'updated_at', as: :date_range

  index :title => "Gesamt"do
    column :guid
    column :name
    column :versiondate
    column :versionid
    column :description
    column :created_at
    column :updated_at
    column :gruppen
    actions #:all, :except => [:edit, :destroy]
  end

  form do |f|

    if gesamt.id == nil
      $uuid=SecureRandom.uuid 
    else
      $uuid=RootTable.find(gesamt.id).guid
    end
    
    f.object.guid = $uuid 
    f.object.versiondate = DateTime.now
    f.object.versionid = RootTable.maximum("versionid")
    f.object.created_at = DateTime.now
    f.object.updated_at = DateTime.now
    f.inputs do
      f.select :art, ["Fachobjekt", "Gruppe", "Externes Dokument"], :prompt => 'Bitte wählen! '
      #f.input :art, as: :select, :include_blank => "Bitte wählen!", label: 'art', :collection => ["Fachobjekt", "Gruppe", "Externes Dokument"]
      #f.input :art, as: :select, :include_blank => "Bitte wählen!", :label => 'art', :collection => ["Fachobjekt", "Gruppe", "Externes Dokument"]
      f.input :guid, :input_html => { :readonly => true }
      f.input :name #, :input_html => { :class => 'name' }
      f.input :versiondate
      f.input :versionid
      f.input :description
      f.input :created_at
      f.input :updated_at
      #f.select :collection, ["Einfriedung", "82fead4f-0bc6-4467-b15f-2f1590c6c1c4", "Rohrleitung"], :prompt => 'Zuordnung Gruppe. '
      #f.input :collection1, as: :select, :include_blank => "Keine Zuordnung.", :collection => 
      #RootTable.joins("INNER JOIN collections ON collections.guid=root_tables.guid").select(:name).uniq
      f.select :collection1, RootTable.joins("INNER JOIN collections ON collections.guid=root_tables.guid")
      .select(:name).uniq, {:include_blank => "Gruppe: Keine Zuordnung."}
      #externaldocument
      #f.template.concat "<h1>Your Ad Here</h1>".html_safe
      
      f.select :externaldocument1, RootTable.joins("INNER JOIN externaldocuments ON externaldocuments.guid=root_tables.guid")
      .select(:name).uniq, {:include_blank => "Dokument: Keine Zuordnung."}
      #f.select :externaldocument1, RootTable.joins("INNER JOIN externaldocuments ON externaldocuments.guid=root_tables.guid")
      #.select(:name).uniq, {:include_blank => "Keine Zuordnung.", :label => 'art'}
      #f.select :externaldocument, :abc => RootTable.joins("INNER JOIN externaldocuments ON externaldocuments.guid=root_tables.guid").select(:name).uniq#, {:include_blank => true}
      #f.input :externaldocument, as: :select, :include_blank => "Bitte wählen!", :collection => 
      #RootTable.joins("INNER JOIN externaldocuments ON externaldocuments.guid=root_tables.guid").select(:name).uniq

    end
    f.actions    
  end

  controller do
    
    after_save :update_object
  
    def update_object(guid)      
      #binding.pry
      #if params[:root_table][:art]  == 'Fachobjekt' #&& params[:root_table][:collection1] != ''
      if params[:root_table][:art]  == 'Fachobjekt' #&& params[:root_table][:collection1] != ''
        ObjectTable.create(:guid => $uuid)
      elsif params[:root_table][:art] == 'Gruppe'
        Collection.create(:guid => $uuid) 
      elsif params[:root_table][:art] == 'Externes Dokument'
        Externaldocument.create(:guid => $uuid) 
      end
      if params[:root_table][:collection1] != ''
        @chosen = params[:root_table][:collection1]
        @chosen_uuid = RootTable.where(name: @chosen).ids[0]
        @ruid = SecureRandom.uuid 
        @guidvalue = $uuid
        #raise @guidvalue.inspect 
        RootTable.create(:guid=>@ruid, :name=>'relationship')
        Relationship.create(:guid=>@ruid) 
        Relassigncollection.create(:guid=>@ruid,:guid_relobject=>@guidvalue,:guid_relcollection=>@chosen_uuid) 
      end
      if params[:root_table][:externaldocument1] != ''
        @chosen = params[:root_table][:externaldocument1]
        @chosen_uuid = RootTable.where(name: @chosen).ids[0]
        @ruid = SecureRandom.uuid 
        @guidvalue = $uuid
        RootTable.create(:guid=>@ruid, :name=>'relationship')
        Relationship.create(:guid=>@ruid) 
        Reldocument.create(:guid=>@ruid,:guid_relroot=>@guidvalue,:guid_reldocument=>@chosen_uuid) 
      end
    end
  end  

  #show do
  #  root_table.name
  #end
end
