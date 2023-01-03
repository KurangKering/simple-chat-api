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

ActiveRecord::Schema[7.0].define(version: 2023_01_03_051333) do
  create_table "friendships", primary_key: ["id_user_1", "id_user_2"], charset: "utf8mb4", force: :cascade do |t|
    t.integer "id_user_1", null: false
    t.integer "id_user_2", null: false
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", primary_key: "id_message", id: :integer, charset: "utf8mb4", force: :cascade do |t|
    t.integer "id_sender", null: false
    t.string "message", null: false
    t.string "type", null: false
    t.integer "id_replay_message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id_replay_message"], name: "index_messages_on_id_replay_message"
    t.index ["id_sender"], name: "index_messages_on_id_sender"
  end

  create_table "users", primary_key: "id_user", id: :integer, charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "phone_number"
    t.string "password", null: false
    t.string "forgot_password_token"
    t.integer "fake_otp"
    t.date "fake_otp_expired_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
