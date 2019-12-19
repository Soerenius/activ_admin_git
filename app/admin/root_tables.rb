ActiveAdmin.register RootTable, as: 'Gesamt' do
  permit_params :guid, :name, :versiondate, :versionid, :description, :created_at, :updated_at, :gruppen, :collections, :relcollects 
  
  menu label: "Gesamt" 

  actions :all, :except => [:new, :edit]

  #filter :"subscription_billing_plan_name" , :as => :select, :collection => RootTable.all.map(&:name)  

  filter :object_table_guid_not_null, label: "Fachobjekte", as: :boolean 
  filter :collection_guid_not_null, label: "Gruppen", as: :boolean 
  filter :name, as: :string, filters: [:contains, :starts_with, :equals, :ends_with]
  filter :versiondate, as: :string, filters: [:contains, :starts_with, :equals, :ends_with]
  filter :versionid, as: :string, filters: [:contains, :starts_with, :equals, :ends_with]
  filter :description, as: :string, filters: [:contains, :starts_with, :equals, :ends_with]
  filter :created_at, label: 'created_at', as: :date_range
  filter :updated_at, label: 'updated_at', as: :date_range
  #filter :name, :collection => RootTable.find_by_sql("SELECT MAX(r.guid) as guid, r.name, COUNT(r.name) as vorkommen
  #FROM root_tables r, object_tables o
  #WHERE r.guid=o.guid
  #GROUP BY r.name
  #HAVING COUNT(r.name)>1"), label: "Doppelte Objekte", as: :check_boxes #.group_by("r.name").having_count("r.name>1")}

  index :title => "Gesamt" do
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
    actions# :all, :except => [:edit, :destroy]
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
    #f.object.created_at = DateTime.now
    f.object.updated_at = DateTime.now
    f.inputs do
      #f.select :art, ["Fachobjekt", "Gruppe", "Externes Dokument"], :prompt => 'Bitte wählen! '
      #f.input :art, as: :select, :include_blank => "Bitte wählen!", :label => 'art', :collection => ["Fachobjekt", "Gruppe", "Externes Dokument"]
      f.input :guid, :input_html => { :readonly => true }
      f.input :name #, :input_html => { :class => 'name' }
      f.input :versiondate
      f.input :versionid
      f.input :description
      #f.input :created_at
      #f.input :updated_at
      #f.input :collection1, as: :select, :include_blank => "Keine Zuordnung.", :collection => 
      #RootTable.joins("INNER JOIN collections ON collections.guid=root_tables.guid").select(:name).uniq
      f.select :collection1, RootTable.joins("INNER JOIN collections ON collections.guid=root_tables.guid")
      .select(:name).uniq, {:include_blank => "Gruppe 1: Keine Zuordnung."}

      f.select :collection2, RootTable.joins("INNER JOIN collections ON collections.guid=root_tables.guid")
      .select(:name).uniq, {:include_blank => "Gruppe 2: Keine Zuordnung."}
      
      f.select :externaldocument1, RootTable.joins("INNER JOIN externaldocuments ON externaldocuments.guid=root_tables.guid")
      .select(:name).uniq, {:include_blank => "Dokument 1: Keine Zuordnung."}
      #f.input :externaldocument, as: :select, :include_blank => "Bitte wählen!", :collection => 
      #RootTable.joins("INNER JOIN externaldocuments ON externaldocuments.guid=root_tables.guid").select(:name).uniq

    end
    f.actions    
  end

  controller do    
    
    after_save :update_object
    after_destroy :destroy_relations
    before_destroy :before_destroy

    def update_object(guid)      
      #binding.pry
      #raise params.inspect
      #if params[:root_table][:art]  == 'Fachobjekt' #&& params[:root_table][:collection1] != ''
      #  ObjectTable.create(:guid => $uuid)
      #elsif params[:root_table][:art] == 'Gruppe'
      #  Collection.create(:guid => $uuid) 
      #elsif params[:root_table][:art] == 'Externes Dokument'
      #  Externaldocument.create(:guid => $uuid) 
      #end
      if params[:root_table][:collection1] != ''
        @chosen = params[:root_table][:collection1]
        @chosen_uuid = RootTable.joins("INNER JOIN collections ON collections.guid=root_tables.guid").where(name: @chosen).ids[0]
        @racuid = SecureRandom.uuid 
        @rcuid = SecureRandom.uuid 
        @guidvalue = $uuid
        #raise @guidvalue.inspect 
        RootTable.create(:guid=>@racuid, :name=>'relationship')
        RootTable.create(:guid=>@rcuid, :name=>'relationship')
        Relationship.create(:guid=>@racuid) 
        Relationship.create(:guid=>@rcuid) 
        Relassigncollection.create(:guid=>@racuid,:guid_relobject=>@guidvalue,:guid_relcollection=>@chosen_uuid) 
        Relcollect.create(:guid=>@rcuid,:guid_relroot=>@guidvalue,:guid_relcollection=>@chosen_uuid) 

      end
      if params[:root_table][:collection2] != ''
        @chosen = params[:root_table][:collection2]
        @chosen_uuid = RootTable.joins("INNER JOIN collections ON collections.guid=root_tables.guid").where(name: @chosen).ids[0]
        @racuid = SecureRandom.uuid 
        @rcuid = SecureRandom.uuid 
        @guidvalue = $uuid
        #raise @guidvalue.inspect 
        RootTable.create(:guid=>@racuid, :name=>'relationship')
        RootTable.create(:guid=>@rcuid, :name=>'relationship')
        Relationship.create(:guid=>@racuid) 
        Relationship.create(:guid=>@rcuid) 
        Relassigncollection.create(:guid=>@racuid,:guid_relobject=>@guidvalue,:guid_relcollection=>@chosen_uuid) 
        Relcollect.create(:guid=>@rcuid,:guid_relroot=>@guidvalue,:guid_relcollection=>@chosen_uuid) 
      end
      if params[:root_table][:externaldocument1] != ''
        @chosen = params[:root_table][:externaldocument1]
        @chosen_uuid = RootTable.joins("INNER JOIN externaldocuments ON externaldocuments.guid=root_tables.guid").where(name: @chosen).ids[0]
        @rduid = SecureRandom.uuid 
        @guidvalue = $uuid
        RootTable.create(:guid=>@rduid, :name=>'relationship')
        Relationship.create(:guid=>@rduid) 
        Reldocument.create(:guid=>@rduid,:guid_relroot=>@guidvalue,:guid_reldocument=>@chosen_uuid) 
      end
    end

    def before_destroy(guid)
      @delete_guid = params[:id]
      @rel_ass_col = Relassigncollection.where(guid_relobject: @delete_guid).ids[0]
      @rel_doc = Reldocument.where(guid_relroot: @delete_guid).ids[0]
      @rel_col = Relcollect.where(guid_relroot: @delete_guid).ids[0]


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

    def destroy_relations(guid)

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
    end
  end
end
