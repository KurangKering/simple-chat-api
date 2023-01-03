class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users, id: false do |t|
      t.integer :id_user, null: false, primary_key: true
      t.string :name, null: false
      t.string :email, null: false, index: {unique: true}
      t.string :phone_number
      t.string :password, null: false
      t.string :forgot_password_token
      t.integer :fake_otp
      t.datetime :fake_otp_expired_time
      t.timestamps
    end

  end
end
