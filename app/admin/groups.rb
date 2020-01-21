ActiveAdmin.register Group, { :sort_order => :name_asc, as: 'Group'  }do
  permit_params :guid, :name, :versiondate, :versionid, :description, :created_at, :updated_at

  menu label: "Gruppe" 

  index :title => "Gruppe" do
    #column :guid
    column :name
    column :versiondate
    column :versionid
    column :description
    column :created_at
    column :updated_at
    column :fachobjekte do |f|      

      RootTable.select("r1.*").from("root_tables r1, root_tables r2, object_tables o, relassigncollections rac, collections c")
      .where("r1.guid=o.guid AND o.guid=rac.guid_relObject AND rac.guid_relCollection=c.guid AND r2.guid=c.guid AND r2.guid='" + f.guid + "'")
      .order("r1.name")

    end
    column :gruppen do |c|      

      RootTable.select("r2.*").from("root_tables r1, root_tables r2, relcollects rc, collections c")
      .where("r1.guid=rc.guid_relroot AND rc.guid_relcollection=c.guid AND r2.guid=c.guid AND r1.guid='" + c.guid + "'")
      .order("r2.name")

    end
    column :dokumente do |d|      

      RootTable.select("r2.*").from("root_tables r1, root_tables r2, reldocuments rd, externaldocuments d")
      .where("r1.guid=rd.guid_relroot AND rd.guid_reldocument=d.guid AND r2.guid=d.guid AND r1.guid='" + d.guid + "'")
      .order("r2.name")

    end
    actions
  end  

  form do |f|

    if group.id == nil
      $uuid=SecureRandom.uuid 
    else
      $uuid=RootTable.find(group.id).guid
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
      f.select :collection1, RootTable.joins("INNER JOIN collections ON collections.guid=root_tables.guid ORDER BY root_tables.name")
      .select(:name).uniq, {:include_blank => "Gruppe 1: Keine Zuordnung."}
      f.select :collection2, RootTable.joins("INNER JOIN collections ON collections.guid=root_tables.guid ORDER BY root_tables.name")
      .select(:name).uniq, {:include_blank => "Gruppe 2: Keine Zuordnung."}
      f.select :externaldocument1, RootTable.joins("INNER JOIN externaldocuments ON externaldocuments.guid=root_tables.guid ORDER BY root_tables.name")
      .select(:name).uniq, {:include_blank => "Dokument 1: Keine Zuordnung."}
      f.select :externaldocument2, RootTable.joins("INNER JOIN externaldocuments ON externaldocuments.guid=root_tables.guid ORDER BY root_tables.name")
      .select(:name).uniq, {:include_blank => "Dokument 2: Keine Zuordnung."}      
    end

    f.actions do
      f.action :submit
      f.action :cancel, label: 'Zurück', button_to: '/db/groups', :wrapper_html => { :class => 'cancel'}
      f.action :cancel, label: "Cancel", :wrapper_html => { :class => 'cancel'}
    end   
  end

  controller do
    
    def scoped_collection
      RootTable.joins(:collection).where("root_tables.guid=collections.guid")
    end

    after_save :update_object
  
    def update_object(guid)
      if Collection.exists?(:guid => $uuid)

      else
        Collection.create(:guid => $uuid)
      end

      $objektname=RootTable.find($uuid).name

      if params[:group][:collection1] != ''
        @chosen = params[:group][:collection1]
        @chosen_uuid = RootTable.joins("INNER JOIN collections ON collections.guid=root_tables.guid").where(name: @chosen).ids[0]
        #raise @chosen.inspect
        @ruid = SecureRandom.uuid 
        @guidvalue = $uuid
        #raise @guidvalue.inspect 
        RootTable.create(:guid=>@ruid, :name=> 'Beziehung "' + $objektname + '" zu "' + @chosen + '". ')
        Relationship.create(:guid=>@ruid) 
        Relcollect.create(:guid=>@ruid,:guid_relroot=>@guidvalue,:guid_relcollection=>@chosen_uuid) 
      end
      if params[:group][:collection2] != ''
        @chosen = params[:group][:collection2]
        @chosen_uuid = RootTable.joins("INNER JOIN collections ON collections.guid=root_tables.guid").where(name: @chosen).ids[0]
        @ruid = SecureRandom.uuid 
        @guidvalue = $uuid
        RootTable.create(:guid=>@ruid, :name=> 'Beziehung "' + $objektname + '" zu "' + @chosen + '". ')
        Relationship.create(:guid=>@ruid) 
        Relcollect.create(:guid=>@ruid,:guid_relroot=>@guidvalue,:guid_relcollection=>@chosen_uuid) 
      end
      if params[:group][:externaldocument1] != ''
        @chosen = params[:group][:externaldocument1]
        @chosen_uuid = RootTable.joins("INNER JOIN externaldocuments ON externaldocuments.guid=root_tables.guid").where(name: @chosen).ids[0]
        @ruid = SecureRandom.uuid 
        @guidvalue = $uuid
        RootTable.create(:guid=>@ruid, :name=> 'Beziehung "' + $objektname + '" zu "' + @chosen + '". ')
        Relationship.create(:guid=>@ruid) 
        Reldocument.create(:guid=>@ruid,:guid_relroot=>@guidvalue,:guid_reldocument=>@chosen_uuid) 
      end
      if params[:group][:externaldocument2] != ''
        @chosen = params[:group][:externaldocument2]
        @chosen_uuid = RootTable.joins("INNER JOIN externaldocuments ON externaldocuments.guid=root_tables.guid").where(name: @chosen).ids[0]
        @ruid = SecureRandom.uuid 
        @guidvalue = $uuid
        RootTable.create(:guid=>@ruid, :name=> 'Beziehung "' + $objektname + '" zu "' + @chosen + '". ')
        Relationship.create(:guid=>@ruid) 
        Reldocument.create(:guid=>@ruid,:guid_relroot=>@guidvalue,:guid_reldocument=>@chosen_uuid) 
      end
    end
    
  end 

  action_item :new_group, priority: 0, only: :show do
    link_to 'Neue Gruppe', '/db/groups/new'
  end

  action_item :back, priority: 1, only: :show do
    link_to 'Zurück', '/db/groups'
  end
  
  show do
    attributes_table  do
      row :guid
      row :name
      row :versiondate
      row :versionid
      row :description
      row :created_at
      row :updated_at
      row :gruppen do |c|
        RootTable.select("r2.*").from("root_tables r1, root_tables r2, relcollects rc, collections c")
      .where("r1.guid=rc.guid_relroot AND rc.guid_relcollection=c.guid AND r2.guid=c.guid AND r1.guid='" + c.guid + "'")
      .order("r2.name")
      end
      row :dokumente do |d|      

        RootTable.select("r2.*").from("root_tables r1, root_tables r2, reldocuments rd, externaldocuments d")
        .where("r1.guid=rd.guid_relroot AND rd.guid_reldocument=d.guid AND r2.guid=d.guid AND r1.guid='" + d.guid + "'")  
        .order("r2.name")
      end
    end
  end

  csv do
    column :guid
    column :name
    column :versiondate
    column :versionid
    column :description
    column :created_at
    column :updated_at
  end
end
