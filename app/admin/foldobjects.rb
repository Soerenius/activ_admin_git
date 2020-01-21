ActiveAdmin.register Foldobject, { :sort_order => :name_asc, as: 'Object' } do
  permit_params :guid, :name, :versiondate, :versionid, :description, :created_at, :updated_at

  menu label: "Fachobjekt" 

  filter :name, as: :string, filters: [:contains, :starts_with, :equals, :ends_with], label: 'Objekt'#, :collection =>  RootTable.find(:guid_relroot) 
  #filter :collection_root_table_name, as: :string, filters: [:contains, :starts_with, :equals, :ends_with], label: 'Gruppe'#, :collection =>  RootTable.find(:guid_relroot) 
  filter :versiondate, as: :string, filters: [:contains, :starts_with, :equals, :ends_with]
  filter :versionid, as: :string, filters: [:contains, :starts_with, :equals, :ends_with]
  filter :description, as: :string, filters: [:contains, :starts_with, :equals, :ends_with]
  filter :created_at, label: 'created_at', as: :date_range
  filter :updated_at, label: 'updated_at', as: :date_range

  index :title => "Fachobjekt" do
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
      f.select :collection1, RootTable.joins("INNER JOIN collections ON collections.guid=root_tables.guid ORDER BY root_tables.name")
      .select(:name).uniq, {:include_blank => "Gruppe 1: Keine Zuordnung."}
      simple_format('<p>f.select :collection1, RootTable.joins("INNER JOIN collections ON collections.guid=root_tables.guid")
      .select(:name).uniq, {:include_blank => "Gruppe 1: Keine Zuordnung."}</p>')
      f.select :collection2, RootTable.joins("INNER JOIN collections ON collections.guid=root_tables.guid ORDER BY root_tables.name")
      .select(:name).uniq, {:include_blank => "Gruppe 2: Keine Zuordnung."}
      f.select :externaldocument1, RootTable.joins("INNER JOIN externaldocuments ON externaldocuments.guid=root_tables.guid ORDER BY root_tables.name")
      .select(:name).uniq, {:include_blank => "Dokument 1: Keine Zuordnung."}
      f.select :externaldocument2, RootTable.joins("INNER JOIN externaldocuments ON externaldocuments.guid=root_tables.guid ORDER BY root_tables.name")
      .select(:name).uniq, {:include_blank => "Dokument 2: Keine Zuordnung."}
    end
    #f.actions  
    f.actions do
      f.action :submit
      f.action :cancel, label: 'Zurück', button_to: '/db/objects', :wrapper_html => { :class => 'cancel'}
      f.action :cancel, label: "Cancel", :wrapper_html => { :class => 'cancel'}
    end
    
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

      $objektname=RootTable.find($uuid).name

      if params[:foldobject][:collection1] != ''
        @chosen = params[:foldobject][:collection1]
        @chosen_uuid = RootTable.joins("INNER JOIN collections ON collections.guid=root_tables.guid").where(name: @chosen).ids[0]
        @racuid = SecureRandom.uuid 
        @rcuid = SecureRandom.uuid 
        @guidvalue = $uuid
        #raise @guidvalue.inspect 
        RootTable.create(:guid=>@racuid, :name=> 'Beziehung "' + $objektname + '" zu "' + @chosen + '". ')
        RootTable.create(:guid=>@rcuid, :name=> 'Beziehung "' + $objektname + '" zu "' + @chosen + '". ')
        Relationship.create(:guid=>@racuid) 
        Relationship.create(:guid=>@rcuid) 
        Relassigncollection.create(:guid=>@racuid,:guid_relobject=>@guidvalue,:guid_relcollection=>@chosen_uuid) 
        Relcollect.create(:guid=>@rcuid,:guid_relroot=>@guidvalue,:guid_relcollection=>@chosen_uuid) 
      end
      if params[:foldobject][:collection2] != ''
        @chosen = params[:foldobject][:collection2]
        @chosen_uuid = RootTable.joins("INNER JOIN collections ON collections.guid=root_tables.guid").where(name: @chosen).ids[0]
        @racuid = SecureRandom.uuid 
        @rcuid = SecureRandom.uuid 
        @guidvalue = $uuid
        #raise @guidvalue.inspect 
        RootTable.create(:guid=>@racuid, :name=> 'Beziehung "' + $objektname + '" zu "' + @chosen + '". ')
        RootTable.create(:guid=>@rcuid, :name=> 'Beziehung "' + $objektname + '" zu "' + @chosen + '". ')
        Relationship.create(:guid=>@racuid) 
        Relationship.create(:guid=>@rcuid) 
        Relassigncollection.create(:guid=>@racuid,:guid_relobject=>@guidvalue,:guid_relcollection=>@chosen_uuid) 
        Relcollect.create(:guid=>@rcuid,:guid_relroot=>@guidvalue,:guid_relcollection=>@chosen_uuid) 
      end
      if params[:foldobject][:externaldocument1] != ''
        @chosen = params[:foldobject][:externaldocument1]
        @chosen_uuid = RootTable.joins("INNER JOIN externaldocuments ON externaldocuments.guid=root_tables.guid").where(name: @chosen).ids[0]
        @ruid = SecureRandom.uuid 
        @guidvalue = $uuid
        RootTable.create(:guid=>@ruid, :name=> 'Beziehung "' + $objektname + '" zu "' + @chosen + '". ')
        Relationship.create(:guid=>@ruid) 
        Reldocument.create(:guid=>@ruid,:guid_relroot=>@guidvalue,:guid_reldocument=>@chosen_uuid) 
      end
      if params[:foldobject][:externaldocument2] != ''
        @chosen = params[:foldobject][:externaldocument1]
        @chosen_uuid = RootTable.joins("INNER JOIN externaldocuments ON externaldocuments.guid=root_tables.guid").where(name: @chosen).ids[0]
        @ruid = SecureRandom.uuid 
        @guidvalue = $uuid
        RootTable.create(:guid=>@ruid, :name=> 'Beziehung "' + $objektname + '" zu "' + @chosen + '". ')
        Relationship.create(:guid=>@ruid) 
        Reldocument.create(:guid=>@ruid,:guid_relroot=>@guidvalue,:guid_reldocument=>@chosen_uuid) 
      end
    end 
    
    def before_destroy(guid)
      @delete_guid = params[:id]
      @rel_ass_col = Relassigncollection.where(guid_relobject: @delete_guid).ids
      @rel_doc = Reldocument.where(guid_relroot: @delete_guid).ids
      @rel_col = Relcollect.where(guid_relroot: @delete_guid).ids
      #@ruid1 = Reldocument.where(guid_relroot: @delete_guid).ids


      if @rel_ass_col != nil
        RootTable.destroy(@rel_ass_col)
      end

      if @rel_doc != nil
        RootTable.destroy(@rel_doc)
      end

      if @rel_col != nil
        RootTable.destroy(@rel_col)
      end

    end
  end 
  
  action_item :new_group, priority: 0, only: :show do
    link_to 'Neues Fachobjekt', '/db/objects/new'
  end

  action_item :back, priority: 1, only: :show do
    link_to 'Zurück', '/db/objects'
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
        RootTable.select("r2.*").from("root_tables r1, root_tables r2, object_tables o, relassigncollections rac, collections c")
      .where("r1.guid=o.guid AND o.guid=rac.guid_relobject AND rac.guid_relcollection=c.guid AND r2.guid=c.guid AND r1.guid='" + c.guid + "'")
      .order("r2.name")      
      end
      row :dokumente do |d|
        RootTable.select("r2.*").from("root_tables r1, root_tables r2, reldocuments rd, externaldocuments d")
        .where("r1.guid=rd.guid_relroot AND rd.guid_reldocument=d.guid AND r2.guid=d.guid AND r1.guid='" + d.guid + "'")
        .order("r2.name")  
      end

      #row :aktion do
      #  link_to 'Zurück', '/db/objects'
      #end
    end 
  end

  index download_links: [:json, :csv]

  csv do
    column :guid
    column :name
    column :versiondate
    column :versionid
    column :description
    column :created_at
    column :updated_at
    #column :string_agg
    #column :fachobjekte do |f|
      #RootTable.find(f.guid).name
      #RootTable.select("r.name").from("root_tables r").where("r.guid=" + f.guid + "").name;

    #  RootTable.select("STRING_AGG (r2.name, ',')").from("root_tables r1, root_tables r2, object_tables o, relassigncollections rac, collections c")
    #  .where("r1.guid=o.guid AND o.guid=rac.guid_relObject AND rac.guid_relCollection=c.guid AND r2.guid=c.guid AND r1.guid='" + f.guid + "'")
    #end


    #( CREATE OR REPLACE VIEW fachobjekte_zu_gruppe_view AS
    #  SELECT r1.guid as id, r1.name,STRING_AGG (r2.name, ',')
    #  FROM root_tables r1, root_tables r2, object_tables o, relassigncollections rac, collections c
    #  WHERE r1.guid=o.guid AND o.guid=rac.guid_relObject AND rac.guid_relCollection=c.guid AND r2.guid=c.guid 
    #  GROUP BY r1.name,r1.guid
  end
end
