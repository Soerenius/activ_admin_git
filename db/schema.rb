# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_12_19_095559) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.string "author_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.uuid "resource_id"
    t.integer "author_id"
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "arts", force: :cascade do |t|
    t.string "art"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "collection1s", force: :cascade do |t|
    t.string "collection1s"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "collection2s", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "collections", primary_key: "guid", id: :string, force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "documents", primary_key: "guid", id: :string, force: :cascade do |t|
    t.string "name"
    t.string "versiondate"
    t.string "versionid"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "externaldocument1s", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "externaldocument2s", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "externaldocuments", primary_key: "guid", id: :string, force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "fachobjekte_gruppen_views", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "fachobjekte_zu_gruppe_views", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "foldobjects", primary_key: "guid", id: :string, force: :cascade do |t|
    t.string "name"
    t.string "versiondate"
    t.string "versionid"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "groups", primary_key: "guid", id: :string, force: :cascade do |t|
    t.string "name"
    t.string "versiondate"
    t.string "versionid"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "object_tables", primary_key: "guid", id: :string, force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "relassigncollections", primary_key: "guid", id: :string, force: :cascade do |t|
    t.string "guid_relobject"
    t.string "guid_relcollection"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "relationships", primary_key: "guid", id: :string, force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "relcollects", primary_key: "guid", id: :string, force: :cascade do |t|
    t.string "guid_relroot"
    t.string "guid_relcollection"
    t.string "guid_typecollection"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "reldocuments", primary_key: "guid", id: :string, force: :cascade do |t|
    t.string "guid_reldocument"
    t.string "guid_relroot"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "root_tables", primary_key: "guid", id: :string, force: :cascade do |t|
    t.string "name"
    t.string "versiondate"
    t.string "versionid"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "collections", "root_tables", column: "guid", primary_key: "guid"
  add_foreign_key "externaldocuments", "root_tables", column: "guid", primary_key: "guid"
  add_foreign_key "object_tables", "root_tables", column: "guid", primary_key: "guid"
  add_foreign_key "relassigncollections", "collections", column: "guid_relcollection", primary_key: "guid"
  add_foreign_key "relassigncollections", "object_tables", column: "guid_relobject", primary_key: "guid"
  add_foreign_key "relcollects", "collections", column: "guid_relcollection", primary_key: "guid"
  add_foreign_key "relcollects", "root_tables", column: "guid_relroot", primary_key: "guid"
  add_foreign_key "reldocuments", "externaldocuments", column: "guid_reldocument", primary_key: "guid"
  add_foreign_key "reldocuments", "root_tables", column: "guid_relroot", primary_key: "guid"

  create_view "fachobjekt_views", sql_definition: <<-SQL
      SELECT r.guid,
      r.name,
      r.versiondate,
      r.versionid,
      r.description
     FROM root_tables r,
      object_tables o
    WHERE ((r.guid)::text = (o.guid)::text);
  SQL
  create_view "fachobjekte_gruppen_view", sql_definition: <<-SQL
      SELECT r1.name,
      string_agg((r2.name)::text, ','::text) AS string_agg
     FROM root_tables r1,
      root_tables r2,
      object_tables o,
      relassigncollections rac,
      collections c
    WHERE (((r1.guid)::text = (o.guid)::text) AND ((o.guid)::text = (rac.guid_relobject)::text) AND ((rac.guid_relcollection)::text = (c.guid)::text) AND ((r2.guid)::text = (c.guid)::text))
    GROUP BY r1.name;
  SQL
  create_view "fachobjekte_zu_gruppe_view", sql_definition: <<-SQL
      SELECT r1.guid AS id,
      r1.name,
      string_agg((r2.name)::text, ','::text) AS string_agg
     FROM root_tables r1,
      root_tables r2,
      object_tables o,
      relassigncollections rac,
      collections c
    WHERE (((r1.guid)::text = (o.guid)::text) AND ((o.guid)::text = (rac.guid_relobject)::text) AND ((rac.guid_relcollection)::text = (c.guid)::text) AND ((r2.guid)::text = (c.guid)::text))
    GROUP BY r1.name, r1.guid;
  SQL
end
