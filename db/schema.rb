# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_01_03_035003) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "account_onboarding_invitation_lists", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.jsonb "invitations"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_account_onboarding_invitation_lists_on_team_id"
  end

  create_table "action_mailbox_inbound_emails", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.string "message_id", null: false
    t.string "message_checksum", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_id", "message_checksum"], name: "index_action_mailbox_inbound_emails_uniqueness", unique: true
  end

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", precision: nil, null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.string "addressable_type", null: false
    t.bigint "addressable_id", null: false
    t.string "address_one"
    t.string "address_two"
    t.string "city"
    t.integer "region_id"
    t.string "region_name"
    t.integer "country_id"
    t.string "postal_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable"
  end

  create_table "demographics", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.integer "sort_order"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_demographics_on_team_id"
  end

  create_table "departments", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.integer "sort_order"
    t.string "name"
    t.boolean "dashboard", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_departments_on_team_id"
  end

  create_table "departments_applied_tags", force: :cascade do |t|
    t.bigint "department_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_departments_applied_tags_on_department_id"
    t.index ["tag_id"], name: "index_departments_applied_tags_on_tag_id"
  end

  create_table "diets", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.integer "sort_order"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "abbreviation"
    t.index ["team_id"], name: "index_diets_on_team_id"
  end

  create_table "flights", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.integer "sort_order"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.boolean "external", default: false
    t.boolean "preflight", default: false
    t.integer "warning_alert"
    t.bigint "flights_timeframe_id"
    t.index ["flights_timeframe_id"], name: "index_flights_on_flights_timeframe_id"
    t.index ["team_id"], name: "index_flights_on_team_id"
  end

  create_table "flights_checks", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.string "name"
    t.bigint "retreat_id"
    t.bigint "flight_id"
    t.bigint "user_id"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["flight_id"], name: "index_flights_checks_on_flight_id"
    t.index ["retreat_id"], name: "index_flights_checks_on_retreat_id"
    t.index ["team_id"], name: "index_flights_checks_on_team_id"
    t.index ["user_id"], name: "index_flights_checks_on_user_id"
  end

  create_table "flights_timeframes", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.integer "sort_order"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_flights_timeframes_on_team_id"
  end

  create_table "games", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.string "red_score"
    t.string "blue_score"
    t.string "yellow_score"
    t.string "green_score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_games_on_team_id"
  end

  create_table "integrations_stripe_installations", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.bigint "oauth_stripe_account_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["oauth_stripe_account_id"], name: "index_stripe_installations_on_stripe_account_id"
    t.index ["team_id"], name: "index_integrations_stripe_installations_on_team_id"
  end

  create_table "invitations", id: :serial, force: :cascade do |t|
    t.string "email"
    t.string "uuid"
    t.integer "from_membership_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "team_id"
    t.bigint "invitation_list_id"
    t.index ["invitation_list_id"], name: "index_invitations_on_invitation_list_id"
    t.index ["team_id"], name: "index_invitations_on_team_id"
  end

  create_table "items", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.string "name"
    t.string "description"
    t.bigint "location_id"
    t.boolean "active", default: false
    t.integer "overlap_offset"
    t.boolean "clean", default: false
    t.integer "flip_time"
    t.integer "beds"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "items_area_id"
    t.string "image_tag"
    t.string "abbreviation"
    t.index ["items_area_id"], name: "index_items_on_items_area_id"
    t.index ["location_id"], name: "index_items_on_location_id"
    t.index ["team_id"], name: "index_items_on_team_id"
  end

  create_table "items_applied_tags", force: :cascade do |t|
    t.bigint "item_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_items_applied_tags_on_item_id"
    t.index ["tag_id"], name: "index_items_applied_tags_on_tag_id"
  end

  create_table "items_areas", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.integer "sort_order"
    t.string "name"
    t.bigint "location_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_items_areas_on_location_id"
    t.index ["team_id"], name: "index_items_areas_on_team_id"
  end

  create_table "items_options", force: :cascade do |t|
    t.bigint "item_id", null: false
    t.integer "sort_order"
    t.string "name"
    t.integer "capacity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.index ["item_id"], name: "index_items_options_on_item_id"
  end

  create_table "items_tags", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.string "name"
    t.boolean "ticketable", default: false
    t.boolean "schedulable", default: false
    t.boolean "optionable", default: false
    t.boolean "exclusivable", default: false
    t.boolean "cleanable", default: false
    t.boolean "publicable", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_items_tags_on_team_id"
  end

  create_table "locations", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.integer "sort_order"
    t.string "name"
    t.string "initials"
    t.integer "capacity"
    t.string "hex_color"
    t.string "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_locations_on_team_id"
  end

  create_table "medforms", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.string "name"
    t.bigint "retreat_id"
    t.string "phone"
    t.string "email"
    t.string "gender"
    t.string "emergency_contact_name"
    t.string "emergency_contact_phone"
    t.string "emergency_contact_relationship"
    t.boolean "terms", default: false
    t.string "form_for"
    t.string "age"
    t.bigint "diet_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["diet_id"], name: "index_medforms_on_diet_id"
    t.index ["retreat_id"], name: "index_medforms_on_retreat_id"
    t.index ["team_id"], name: "index_medforms_on_team_id"
  end

  create_table "memberships", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "team_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "invitation_id"
    t.string "user_first_name"
    t.string "user_last_name"
    t.string "user_profile_photo_id"
    t.string "user_email"
    t.bigint "added_by_id"
    t.bigint "platform_agent_of_id"
    t.jsonb "role_ids", default: []
    t.boolean "platform_agent", default: false
    t.index ["added_by_id"], name: "index_memberships_on_added_by_id"
    t.index ["invitation_id"], name: "index_memberships_on_invitation_id"
    t.index ["platform_agent_of_id"], name: "index_memberships_on_platform_agent_of_id"
    t.index ["team_id"], name: "index_memberships_on_team_id"
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.string "name"
    t.bigint "user_id"
    t.datetime "read_at"
    t.boolean "emailed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "notifiable_type", null: false
    t.bigint "notifiable_id", null: false
    t.index ["notifiable_type", "notifiable_id"], name: "index_notifications_on_notifiable"
    t.index ["team_id"], name: "index_notifications_on_team_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "notifications_archive_actions", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.boolean "target_all", default: false
    t.jsonb "target_ids", default: []
    t.jsonb "failed_ids", default: []
    t.integer "last_completed_id", default: 0
    t.datetime "started_at"
    t.datetime "completed_at"
    t.integer "target_count"
    t.integer "performed_count", default: 0
    t.datetime "scheduled_for"
    t.string "sidekiq_jid"
    t.bigint "created_by_id", null: false
    t.bigint "approved_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approved_by_id"], name: "index_notifications_archives_on_approved_by_id"
    t.index ["created_by_id"], name: "index_notifications_archives_on_created_by_id"
    t.index ["team_id"], name: "index_notifications_archive_actions_on_team_id"
  end

  create_table "notifications_flags", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.string "name"
    t.bigint "department_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_notifications_flags_on_department_id"
    t.index ["team_id"], name: "index_notifications_flags_on_team_id"
  end

  create_table "notifications_requests", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.string "name"
    t.bigint "user_id"
    t.bigint "notifications_flag_id"
    t.integer "days_before"
    t.boolean "email", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notifications_flag_id"], name: "index_notifications_requests_on_notifications_flag_id"
    t.index ["team_id"], name: "index_notifications_requests_on_team_id"
    t.index ["user_id"], name: "index_notifications_requests_on_user_id"
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.bigint "resource_owner_id", null: false
    t.bigint "application_id", null: false
    t.string "token", null: false
    t.integer "expires_in", null: false
    t.text "redirect_uri", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "revoked_at", precision: nil
    t.string "scopes", default: "", null: false
    t.index ["application_id"], name: "index_oauth_access_grants_on_application_id"
    t.index ["resource_owner_id"], name: "index_oauth_access_grants_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true
  end

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.bigint "resource_owner_id"
    t.bigint "application_id", null: false
    t.string "token", null: false
    t.string "refresh_token"
    t.integer "expires_in"
    t.datetime "revoked_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.string "scopes"
    t.string "previous_refresh_token", default: "", null: false
    t.string "description"
    t.datetime "last_used_at"
    t.boolean "provisioned", default: false
    t.index ["application_id"], name: "index_oauth_access_tokens_on_application_id"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_applications", force: :cascade do |t|
    t.string "name", null: false
    t.string "uid", null: false
    t.string "secret", null: false
    t.text "redirect_uri"
    t.string "scopes", default: "", null: false
    t.boolean "confidential", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "team_id"
    t.index ["team_id"], name: "index_oauth_applications_on_team_id"
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end

  create_table "oauth_stripe_accounts", force: :cascade do |t|
    t.string "uid"
    t.jsonb "data"
    t.bigint "user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["uid"], name: "index_oauth_stripe_accounts_on_uid", unique: true
    t.index ["user_id"], name: "index_oauth_stripe_accounts_on_user_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.string "name"
    t.string "website"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_organizations_on_team_id"
  end

  create_table "organizations_contacts", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "job_title"
    t.string "primary_phone"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_organizations_contacts_on_team_id"
  end

  create_table "questions", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.integer "sort_order"
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_questions_on_team_id"
  end

  create_table "questions_demographic_tags", force: :cascade do |t|
    t.bigint "question_id", null: false
    t.bigint "demographic_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["demographic_id"], name: "index_questions_demographic_tags_on_demographic_id"
    t.index ["question_id"], name: "index_questions_demographic_tags_on_question_id"
  end

  create_table "questions_location_tags", force: :cascade do |t|
    t.bigint "question_id", null: false
    t.bigint "location_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_questions_location_tags_on_location_id"
    t.index ["question_id"], name: "index_questions_location_tags_on_question_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.string "name"
    t.bigint "retreat_id"
    t.bigint "item_id"
    t.bigint "user_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer "quantity"
    t.string "notes"
    t.boolean "seasonal_default", default: false
    t.boolean "exclusive", default: false
    t.boolean "active", default: false
    t.string "dining_style"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "items_option_id"
    t.date "planned_cleaning_date"
    t.index ["item_id"], name: "index_reservations_on_item_id"
    t.index ["items_option_id"], name: "index_reservations_on_items_option_id"
    t.index ["retreat_id"], name: "index_reservations_on_retreat_id"
    t.index ["team_id"], name: "index_reservations_on_team_id"
    t.index ["user_id"], name: "index_reservations_on_user_id"
  end

  create_table "retreats", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.string "name"
    t.string "description"
    t.datetime "arrival"
    t.datetime "departure"
    t.integer "contract_count"
    t.bigint "organization_id"
    t.boolean "internal", default: false
    t.boolean "active", default: false
    t.integer "actual_count"
    t.integer "nps"
    t.string "debrief"
    t.string "dining_style"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "program_event", default: false
    t.index ["organization_id"], name: "index_retreats_on_organization_id"
    t.index ["team_id"], name: "index_retreats_on_team_id"
  end

  create_table "retreats_assigned_contacts", force: :cascade do |t|
    t.bigint "retreat_id", null: false
    t.bigint "contact_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id"], name: "index_retreats_assigned_contacts_on_contact_id"
    t.index ["retreat_id"], name: "index_retreats_assigned_contacts_on_retreat_id"
  end

  create_table "retreats_comments", force: :cascade do |t|
    t.bigint "retreat_id", null: false
    t.string "name"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["retreat_id"], name: "index_retreats_comments_on_retreat_id"
    t.index ["user_id"], name: "index_retreats_comments_on_user_id"
  end

  create_table "retreats_demographic_tags", force: :cascade do |t|
    t.bigint "retreat_id", null: false
    t.bigint "demographic_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["demographic_id"], name: "index_retreats_demographic_tags_on_demographic_id"
    t.index ["retreat_id"], name: "index_retreats_demographic_tags_on_retreat_id"
  end

  create_table "retreats_host_tags", force: :cascade do |t|
    t.bigint "retreat_id", null: false
    t.bigint "host_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["host_id"], name: "index_retreats_host_tags_on_host_id"
    t.index ["retreat_id"], name: "index_retreats_host_tags_on_retreat_id"
  end

  create_table "retreats_location_tags", force: :cascade do |t|
    t.bigint "retreat_id", null: false
    t.bigint "location_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_retreats_location_tags_on_location_id"
    t.index ["retreat_id"], name: "index_retreats_location_tags_on_retreat_id"
  end

  create_table "retreats_planner_tags", force: :cascade do |t|
    t.bigint "retreat_id", null: false
    t.bigint "planner_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["planner_id"], name: "index_retreats_planner_tags_on_planner_id"
    t.index ["retreat_id"], name: "index_retreats_planner_tags_on_retreat_id"
  end

  create_table "retreats_requests", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.bigint "retreat_id", null: false
    t.bigint "department_id"
    t.string "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_retreats_requests_on_department_id"
    t.index ["retreat_id"], name: "index_retreats_requests_on_retreat_id"
    t.index ["team_id"], name: "index_retreats_requests_on_team_id"
  end

  create_table "scaffolding_absolutely_abstract_creative_concepts", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_absolutely_abstract_creative_concepts_on_team_id"
  end

  create_table "scaffolding_completely_concrete_tangible_things", force: :cascade do |t|
    t.bigint "absolutely_abstract_creative_concept_id", null: false
    t.string "text_field_value"
    t.string "button_value"
    t.string "cloudinary_image_value"
    t.date "date_field_value"
    t.string "email_field_value"
    t.string "password_field_value"
    t.string "phone_field_value"
    t.string "super_select_value"
    t.text "text_area_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sort_order"
    t.datetime "date_and_time_field_value", precision: nil
    t.jsonb "multiple_button_values", default: []
    t.jsonb "multiple_super_select_values", default: []
    t.string "color_picker_value"
    t.boolean "boolean_button_value"
    t.string "option_value"
    t.jsonb "multiple_option_values", default: []
    t.boolean "boolean_checkbox_value"
    t.index ["absolutely_abstract_creative_concept_id"], name: "index_tangible_things_on_creative_concept_id"
  end

  create_table "scaffolding_completely_concrete_tangible_things_assignments", force: :cascade do |t|
    t.bigint "tangible_thing_id"
    t.bigint "membership_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["membership_id"], name: "index_tangible_things_assignments_on_membership_id"
    t.index ["tangible_thing_id"], name: "index_tangible_things_assignments_on_tangible_thing_id"
  end

  create_table "seasons", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.string "name"
    t.bigint "item_id"
    t.datetime "season_start"
    t.datetime "season_end"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer "quantity"
    t.string "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_seasons_on_item_id"
    t.index ["team_id"], name: "index_seasons_on_team_id"
  end

  create_table "teams", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "being_destroyed"
    t.string "time_zone"
    t.string "locale"
    t.string "item_query"
    t.string "circuitree_api"
    t.string "groups_query"
    t.string "reservation_download"
    t.string "programs_query"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "current_team_id"
    t.string "first_name"
    t.string "last_name"
    t.string "time_zone"
    t.datetime "last_seen_at", precision: nil
    t.string "profile_photo_id"
    t.jsonb "ability_cache"
    t.datetime "last_notification_email_sent_at", precision: nil
    t.boolean "former_user", default: false, null: false
    t.string "encrypted_otp_secret"
    t.string "encrypted_otp_secret_iv"
    t.string "encrypted_otp_secret_salt"
    t.integer "consumed_timestep"
    t.boolean "otp_required_for_login"
    t.string "otp_backup_codes", array: true
    t.string "locale"
    t.bigint "platform_agent_of_id"
    t.string "otp_secret"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["platform_agent_of_id"], name: "index_users_on_platform_agent_of_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "whodunnit"
    t.datetime "created_at"
    t.bigint "item_id", null: false
    t.string "item_type", null: false
    t.string "event", null: false
    t.text "object"
    t.text "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "webhooks_incoming_bullet_train_webhooks", force: :cascade do |t|
    t.jsonb "data"
    t.datetime "processed_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.datetime "verified_at", precision: nil
  end

  create_table "webhooks_incoming_oauth_stripe_account_webhooks", force: :cascade do |t|
    t.jsonb "data"
    t.datetime "processed_at", precision: nil
    t.datetime "verified_at", precision: nil
    t.bigint "oauth_stripe_account_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["oauth_stripe_account_id"], name: "index_stripe_webhooks_on_stripe_account_id"
  end

  create_table "webhooks_outgoing_deliveries", force: :cascade do |t|
    t.integer "endpoint_id"
    t.integer "event_id"
    t.text "endpoint_url"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.datetime "delivered_at", precision: nil
  end

  create_table "webhooks_outgoing_delivery_attempts", force: :cascade do |t|
    t.integer "delivery_id"
    t.integer "response_code"
    t.text "response_body"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "response_message"
    t.text "error_message"
    t.integer "attempt_number"
  end

  create_table "webhooks_outgoing_endpoints", force: :cascade do |t|
    t.bigint "team_id"
    t.text "url"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "name"
    t.jsonb "event_type_ids", default: []
    t.bigint "scaffolding_absolutely_abstract_creative_concept_id"
    t.integer "api_version", null: false
    t.index ["scaffolding_absolutely_abstract_creative_concept_id"], name: "index_endpoints_on_abstract_creative_concept_id"
    t.index ["team_id"], name: "index_webhooks_outgoing_endpoints_on_team_id"
  end

  create_table "webhooks_outgoing_events", force: :cascade do |t|
    t.integer "subject_id"
    t.string "subject_type"
    t.jsonb "data"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "team_id"
    t.string "uuid"
    t.jsonb "payload"
    t.string "event_type_id"
    t.integer "api_version", null: false
    t.index ["team_id"], name: "index_webhooks_outgoing_events_on_team_id"
  end

  create_table "websiteimages", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_websiteimages_on_team_id"
  end

  add_foreign_key "account_onboarding_invitation_lists", "teams"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "demographics", "teams"
  add_foreign_key "departments", "teams"
  add_foreign_key "departments_applied_tags", "departments"
  add_foreign_key "departments_applied_tags", "items_tags", column: "tag_id"
  add_foreign_key "diets", "teams"
  add_foreign_key "flights", "flights_timeframes"
  add_foreign_key "flights", "teams"
  add_foreign_key "flights_checks", "flights"
  add_foreign_key "flights_checks", "memberships", column: "user_id"
  add_foreign_key "flights_checks", "retreats"
  add_foreign_key "flights_checks", "teams"
  add_foreign_key "flights_timeframes", "teams"
  add_foreign_key "games", "teams"
  add_foreign_key "integrations_stripe_installations", "oauth_stripe_accounts"
  add_foreign_key "integrations_stripe_installations", "teams"
  add_foreign_key "invitations", "account_onboarding_invitation_lists", column: "invitation_list_id"
  add_foreign_key "invitations", "teams"
  add_foreign_key "items", "items_areas"
  add_foreign_key "items", "locations"
  add_foreign_key "items", "teams"
  add_foreign_key "items_applied_tags", "items"
  add_foreign_key "items_applied_tags", "items_tags", column: "tag_id"
  add_foreign_key "items_areas", "locations"
  add_foreign_key "items_areas", "teams"
  add_foreign_key "items_options", "items"
  add_foreign_key "items_tags", "teams"
  add_foreign_key "locations", "teams"
  add_foreign_key "medforms", "diets"
  add_foreign_key "medforms", "retreats"
  add_foreign_key "medforms", "teams"
  add_foreign_key "memberships", "invitations"
  add_foreign_key "memberships", "memberships", column: "added_by_id"
  add_foreign_key "memberships", "oauth_applications", column: "platform_agent_of_id"
  add_foreign_key "memberships", "teams"
  add_foreign_key "memberships", "users"
  add_foreign_key "notifications", "memberships", column: "user_id"
  add_foreign_key "notifications", "teams"
  add_foreign_key "notifications_archive_actions", "memberships", column: "approved_by_id"
  add_foreign_key "notifications_archive_actions", "memberships", column: "created_by_id"
  add_foreign_key "notifications_archive_actions", "teams"
  add_foreign_key "notifications_flags", "departments"
  add_foreign_key "notifications_flags", "teams"
  add_foreign_key "notifications_requests", "memberships", column: "user_id"
  add_foreign_key "notifications_requests", "notifications_flags"
  add_foreign_key "notifications_requests", "teams"
  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_applications", "teams"
  add_foreign_key "oauth_stripe_accounts", "users"
  add_foreign_key "organizations", "teams"
  add_foreign_key "organizations_contacts", "teams"
  add_foreign_key "questions", "teams"
  add_foreign_key "questions_demographic_tags", "demographics"
  add_foreign_key "questions_demographic_tags", "questions"
  add_foreign_key "questions_location_tags", "locations"
  add_foreign_key "questions_location_tags", "questions"
  add_foreign_key "reservations", "items"
  add_foreign_key "reservations", "items_options"
  add_foreign_key "reservations", "memberships", column: "user_id"
  add_foreign_key "reservations", "retreats"
  add_foreign_key "reservations", "teams"
  add_foreign_key "retreats", "organizations"
  add_foreign_key "retreats", "teams"
  add_foreign_key "retreats_assigned_contacts", "organizations_contacts", column: "contact_id"
  add_foreign_key "retreats_assigned_contacts", "retreats"
  add_foreign_key "retreats_comments", "memberships", column: "user_id"
  add_foreign_key "retreats_comments", "retreats"
  add_foreign_key "retreats_demographic_tags", "demographics"
  add_foreign_key "retreats_demographic_tags", "retreats"
  add_foreign_key "retreats_host_tags", "memberships", column: "host_id"
  add_foreign_key "retreats_host_tags", "retreats"
  add_foreign_key "retreats_location_tags", "locations"
  add_foreign_key "retreats_location_tags", "retreats"
  add_foreign_key "retreats_planner_tags", "memberships", column: "planner_id"
  add_foreign_key "retreats_planner_tags", "retreats"
  add_foreign_key "retreats_requests", "departments"
  add_foreign_key "retreats_requests", "retreats"
  add_foreign_key "retreats_requests", "teams"
  add_foreign_key "scaffolding_absolutely_abstract_creative_concepts", "teams"
  add_foreign_key "scaffolding_completely_concrete_tangible_things", "scaffolding_absolutely_abstract_creative_concepts", column: "absolutely_abstract_creative_concept_id"
  add_foreign_key "scaffolding_completely_concrete_tangible_things_assignments", "memberships"
  add_foreign_key "scaffolding_completely_concrete_tangible_things_assignments", "scaffolding_completely_concrete_tangible_things", column: "tangible_thing_id"
  add_foreign_key "seasons", "items"
  add_foreign_key "seasons", "teams"
  add_foreign_key "users", "oauth_applications", column: "platform_agent_of_id"
  add_foreign_key "webhooks_outgoing_endpoints", "scaffolding_absolutely_abstract_creative_concepts"
  add_foreign_key "webhooks_outgoing_endpoints", "teams"
  add_foreign_key "webhooks_outgoing_events", "teams"
  add_foreign_key "websiteimages", "teams"
end
