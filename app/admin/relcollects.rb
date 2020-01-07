ActiveAdmin.register Relcollect do
  permit_params :guid, :guid_relroot, :guid_relcollection, :guid_typecollection, :root_table, :collection, :relationship

  actions :all, :except => [:new, :edit]
  
  menu label: "Zugeord. Gruppen" 

  filter :root_table_name, as: :string, filters: [:contains, :starts_with, :equals, :ends_with], label: 'Objekt'#, :collection =>  RootTable.find(:guid_relroot) 
  filter :collection_root_table_name, as: :string, filters: [:contains, :starts_with, :equals, :ends_with], label: 'Dokument'#, :collection =>  RootTable.find(:guid_relroot) 

  scope :all, :default => true

  index :title => "Zugeord. Gruppen" do
    #column "guid", :guid
    column "Objekt" do |r| #, sortable: 'root_tables.name'
      RootTable.find(r.guid_relroot)
    end
    column "Gruppe" do |m|#, :collection , sortable: 'root_tables.name'
      RootTable.find(m.guid_relcollection)
    end
    column :created_at
    column :updated_at
    actions
  end

=begin
  form do |f|

    
    #f.object.guid = $uuid 
    #f.object.versiondate = DateTime.now
    #f.object.versionid = RootTable.maximum("versionid")
    #f.object.created_at = DateTime.now
    #f.object.updated_at = DateTime.now
    #    f.object.guid_relcollection = RootTable.select("r.guid").from("root_tables r").where("r.name='Beschilderung")
    #f.object.guid_relcollection = RootTable.select("r.guid").from("root_tables r").where("r.name='Beschilderung")
    f.inputs do
      #f.select :art, ["Fachobjekt", "Gruppe", "Externes Dokument"], :prompt => 'Bitte wählen! '
      #f.input :art, as: :select, :include_blank => "Bitte wählen!", :label => 'art', :collection => ["Fachobjekt", "Gruppe", "Externes Dokument"]
      
      f.input :root_table
      #f.select :root_table, RootTable.all
      #.select(:name).uniq, {:include_blank => "Subjekt: Keine Zuordnung."}
      #f.select :collection, RootTable.joins("INNER JOIN collections ON collections.guid=root_tables.guid")
      #.select(:name).uniq, {:include_blank => "Gruppe: Keine Zuordnung."}
      f.input :collection
      #f.input :relationship
      f.input :guid_relroot
      if f.object.new_record?
        #f.object.relationship = SecureRandom.uuid 
        f.input :relationship 
      else
        f.input :relationship
      end
      f.input :guid_relcollection, as: :select, :collection => 
      RootTable.joins("INNER JOIN collections ON collections.guid=root_tables.guid").select(:name).uniq
      #f.input :guid_relcollection
      f.input :guid_typecollection

      
      @ja = params[:root_table]#[:relcollect]
      #raise @ja.inspect
      #f.input :name #, :input_html => { :class => 'name' }
      #f.input :versiondate
      #f.input :versionid
      #f.input :description
      #f.input :created_at
      #f.input :updated_at
      #f.input :collection1, as: :select, :include_blank => "Keine Zuordnung.", :collection => 
      #RootTable.joins("INNER JOIN collections ON collections.guid=root_tables.guid").select(:name).uniq
      #f.select :collection1, RootTable.joins("INNER JOIN collections ON collections.guid=root_tables.guid")
      #.select(:name).uniq, {:include_blank => "Gruppe 1: Keine Zuordnung."}

      #f.select :collection2, RootTable.joins("INNER JOIN collections ON collections.guid=root_tables.guid")
      #.select(:name).uniq, {:include_blank => "Gruppe 2: Keine Zuordnung."}
      
      #f.select :externaldocument1, RootTable.joins("INNER JOIN externaldocuments ON externaldocuments.guid=root_tables.guid")
      #.select(:name).uniq, {:include_blank => "Dokument 1: Keine Zuordnung."}
      #f.input :externaldocument, as: :select, :include_blank => "Bitte wählen!", :collection => 
      #RootTable.joins("INNER JOIN externaldocuments ON externaldocuments.guid=root_tables.guid").select(:name).uniq

    end
    f.actions    
  end
=end
  controller do  

=begin
    before_save :update_object
    after_destroy :destroy_relations
    before_destroy :before_destroy

    def update_object(guid)   
      @chosen = params[:relcollect][:collection]
      @chosen_uuid = RootTable.joins("INNER JOIN collections ON collections.guid=root_tables.guid").where(name: @chosen).ids[0]
      @chosenz = params[:relcollect][:guid_relcollection]
      #raise params.inspect
      #:guid_relcollection => @chosen_uuid
      #raise @chosenz.inspect
      #raise params.inspect
    end

    #def new
    #  @relcollect = Relcollect.new
    #  @relcollect.build_relationship
    #end

=end

    def scoped_collection
      super.includes :root_table # prevents N+1 queries to your database
    end
    
  end
  
end
