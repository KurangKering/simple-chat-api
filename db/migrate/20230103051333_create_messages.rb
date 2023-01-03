class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages, id: false do |t|
      t.integer :id_message, primary_key: true, null: false
      t.integer :id_sender, null: false, index: true
      t.string :message, null: false
      t.string :type, null: false
      t.integer :id_replay_message, index: true
      t.timestamps
    end
  end
end
