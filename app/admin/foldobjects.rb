ActiveAdmin.register Foldobject, as: 'Object' do
  permit_params :guid, :name, :versiondate, :versionid, :description, :created_at, :updated_at

  menu label: "Klasse" 

  filter :name, as: :string, filters: [:contains, :starts_with, :equals, :ends_with], label: 'Objekt'#, :collection =>  RootTable.find(:guid_relroot) 
  #filter :collection_root_table_name, as: :string, filters: [:contains, :starts_with, :equals, :ends_with], label: 'Gruppe'#, :collection =>  RootTable.find(:guid_relroot) 
  filter :versiondate, as: :string, filters: [:contains, :starts_with, :equals, :ends_with]
  filter :versionid, as: :string, filters: [:contains, :starts_with, :equals, :ends_with]
  filter :description, as: :string, filters: [:contains, :starts_with, :equals, :ends_with]
  filter :created_at, label: 'created_at', as: :date_range
  filter :updated_at, label: 'updated_at', as: :date_range

  index :title => "Klasse" do
    #column :guid
    column :name
    column :versiondate
    column :versionid
    column :description
    column :created_at
    column :updated_at
    column :gruppen do |c|      

      RootTable.select("r2.*").from("root_tables r1, root_tables r2, object_tables o, relassigncollections rac, collections c")
      .where("r1.guid=o.guid AND o.guid=rac.guid_relobject AND rac.guid_relcollection=c.guid AND r2.guid=c.guid AND r1.guid='" + c.guid + "'")

    end
    column :dokumente do |d|      

      RootTable.select("r2.*").from("root_tables r1, root_tables r2, reldocuments rd, externaldocuments d")
      .where("r1.guid=rd.guid_relroot AND rd.guid_reldocument=d.guid AND r2.guid=d.guid AND r1.guid='" + d.guid + "'")

    end
    actions
  end  

  form do |f|

    if object.id == nil
      $uuid=SecureRandom.uuid 
    else
      $uuid=RootTable.find(object.id).guid
    end

    f.object.guid = $uuid 
    f.object.versiondate = DateTime.now
    f.object.versionid = RootTable.maximum("versionid")
    #f.object.created_at = DateTime.now
    f.object.updated_at = DateTime.now
    f.inputs do
      f.input :guid, :input_html => { :readonly => true }
      f.input :name
      f.input :versiondate
      f.input :versionid
      f.input :description
      #f.input :created_at
      #f.input :updated_at
      f.select :collection1, RootTable.joins("INNER JOIN collections ON collections.guid=root_tables.guid")
      .select(:name).uniq, {:include_blank => "Gruppe 1: Keine Zuordnung."}
      simple_format('<p>f.select :collection1, RootTable.joins("INNER JOIN collections ON collections.guid=root_tables.guid")
      .select(:name).uniq, {:include_blank => "Gruppe 1: Keine Zuordnung."}</p>')
      f.select :collection2, RootTable.joins("INNER JOIN collections ON collections.guid=root_tables.guid")
      .select(:name).uniq, {:include_blank => "Gruppe 2: Keine Zuordnung."}
      f.select :externaldocument1, RootTable.joins("INNER JOIN externaldocuments ON externaldocuments.guid=root_tables.guid")
      .select(:name).uniq, {:include_blank => "Dokument 1: Keine Zuordnung."}
      f.select :externaldocument2, RootTable.joins("INNER JOIN externaldocuments ON externaldocuments.guid=root_tables.guid")
      .select(:name).uniq, {:include_blank => "Dokument 2: Keine Zuordnung."}
    end
    f.actions  
    
  end

  controller do
    
    def scoped_collection
      RootTable.joins(:object_table).where("root_tables.guid=object_tables.guid")
    end

    after_save :update_object
  
    def update_object(guid)
      if ObjectTable.exists?(:guid => $uuid)
        
      else
        ObjectTable.create(:guid => $uuid)
      end      

      if params[:foldobject][:collection1] != ''
        @chosen = params[:foldobject][:collection1]
        @chosen_uuid = RootTable.joins("INNER JOIN collections ON collections.guid=root_tables.guid").where(name: @chosen).ids[0]
        @ruid = SecureRandom.uuid 
        @guidvalue = $uuid
        #raise @guidvalue.inspect 
        RootTable.create(:guid=>@ruid, :name=>'relationship')
        Relationship.create(:guid=>@ruid) 
        Relassigncollection.create(:guid=>@ruid,:guid_relobject=>@guidvalue,:guid_relcollection=>@chosen_uuid) 
      end
      if params[:foldobject][:collection2] != ''
        @chosen = params[:foldobject][:collection2]
        @chosen_uuid = RootTable.joins("INNER JOIN collections ON collections.guid=root_tables.guid").where(name: @chosen).ids[0]
        @ruid = SecureRandom.uuid 
        @guidvalue = $uuid
        #raise @guidvalue.inspect 
        RootTable.create(:guid=>@ruid, :name=>'relationship')
        Relationship.create(:guid=>@ruid) 
        Relassigncollection.create(:guid=>@ruid,:guid_relobject=>@guidvalue,:guid_relcollection=>@chosen_uuid) 
      end
      if params[:foldobject][:externaldocument1] != ''
        @chosen = params[:foldobject][:externaldocument1]
        @chosen_uuid = RootTable.joins("INNER JOIN externaldocuments ON externaldocuments.guid=root_tables.guid").where(name: @chosen).ids[0]
        @ruid = SecureRandom.uuid 
        @guidvalue = $uuid
        RootTable.create(:guid=>@ruid, :name=>'relationship')
        Relationship.create(:guid=>@ruid) 
        Reldocument.create(:guid=>@ruid,:guid_relroot=>@guidvalue,:guid_reldocument=>@chosen_uuid) 
      end
      if params[:foldobject][:externaldocument2] != ''
        @chosen = params[:foldobject][:externaldocument1]
        @chosen_uuid = RootTable.joins("INNER JOIN externaldocuments ON externaldocuments.guid=root_tables.guid").where(name: @chosen).ids[0]
        @ruid = SecureRandom.uuid 
        @guidvalue = $uuid
        RootTable.create(:guid=>@ruid, :name=>'relationship')
        Relationship.create(:guid=>@ruid) 
        Reldocument.create(:guid=>@ruid,:guid_relroot=>@guidvalue,:guid_reldocument=>@chosen_uuid) 
      end
    end    
  end  

  show do
    attributes_table  do
      row :name
      row :versiondate
      row :versionid
      row :description
      row :created_at
      row :updated_at
      row :gruppen do |c|
        RootTable.select("r2.*").from("root_tables r1, root_tables r2, object_tables o, relassigncollections rac, collections c")
      .where("r1.guid=o.guid AND o.guid=rac.guid_relobject AND rac.guid_relcollection=c.guid AND r2.guid=c.guid AND r1.guid='" + c.guid + "'")      
      end
      row :dokumente do |d|
        RootTable.select("r2.*").from("root_tables r1, root_tables r2, reldocuments rd, externaldocuments d")
        .where("r1.guid=rd.guid_relroot AND rd.guid_reldocument=d.guid AND r2.guid=d.guid AND r1.guid='" + d.guid + "'")  
      end
    end
  end
end
