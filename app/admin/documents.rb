ActiveAdmin.register Document do
  permit_params :guid, :name, :versiondate, :versionid, :description, :created_at, :updated_at

  menu label: "Dokumente" 

  index :title => "Dokumente" do
    #column :guid
    column :name
    column :versiondate
    column :versionid
    column :description
    column :created_at
    column :updated_at
    column :gruppen do |c|   
      RootTable.select("r2.*").from("root_tables r1, root_tables r2, relcollects rc, collections c")
      .where("r1.guid=rc.guid_relroot AND rc.guid_relcollection=c.guid AND r2.guid=c.guid AND r1.guid='" + c.guid + "'")
    end
    column :dokumente do |d|  
      RootTable.select("r2.*").from("root_tables r1, root_tables r2, reldocuments rd, externaldocuments d")
      .where("r1.guid=rd.guid_relroot AND rd.guid_reldocument=d.guid AND r2.guid=d.guid AND r1.guid='" + d.guid + "'")
    end
    actions
  end  

  form do |f|

    if document.id == nil
      $uuid=SecureRandom.uuid 
    else
      $uuid=RootTable.find(document.id).guid
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
      .select(:name).uniq, {:include_blank => "Gruppe: Keine Zuordnung."}
      f.select :externaldocument1, RootTable.joins("INNER JOIN externaldocuments ON externaldocuments.guid=root_tables.guid")
      .select(:name).uniq, {:include_blank => "Dokument: Keine Zuordnung."}
    end
    f.actions    
  end

  controller do
    
    def scoped_collection
      RootTable.joins(:externaldocument).where("root_tables.guid=externaldocuments.guid")
    end

    after_save :update_object
  
    def update_object(guid)
      Externaldocument.create(:guid => $uuid)

      if params[:group][:collection1] != ''
        @chosen = params[:group][:collection1]
        @chosen_uuid = RootTable.joins("INNER JOIN collections ON collections.guid=root_tables.guid").where(name: @chosen).ids[0]
        @ruid = SecureRandom.uuid 
        @guidvalue = $uuid
        #raise @guidvalue.inspect 
        RootTable.create(:guid=>@ruid, :name=>'relationship')
        Relationship.create(:guid=>@ruid) 
        Relassigncollection.create(:guid=>@ruid,:guid_relobject=>@guidvalue,:guid_relcollection=>@chosen_uuid) 
      end
      if params[:group][:externaldocument1] != ''
        @chosen = params[:group][:externaldocument1]
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
        RootTable.select("r2.*").from("root_tables r1, root_tables r2, relcollects rc, collections c")
      .where("r1.guid=rc.guid_relroot AND rc.guid_relcollection=c.guid AND r2.guid=c.guid AND r1.guid='" + c.guid + "'")
      end
      row :dokumente do |d|  
        RootTable.select("r2.*").from("root_tables r1, root_tables r2, reldocuments rd, externaldocuments d")
        .where("r1.guid=rd.guid_relroot AND rd.guid_reldocument=d.guid AND r2.guid=d.guid AND r1.guid='" + d.guid + "'")
      end
    end
  end  
end
