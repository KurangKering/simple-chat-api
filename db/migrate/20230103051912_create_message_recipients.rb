class CreateMessageRecipients < ActiveRecord::Migration[7.0]
  def change
    create_table :message_recipients, id:false do |t|
      t.integer :id_message
      t.integer :id_recipient
      t.integer :is_read
      t.datetime :read_at
      t.timestamps
    end

    reversible do | dir |
      dir.up do
        execute "ALTER TABLE #{:message_recipients} ADD PRIMARY KEY (id_message,id_recipient);"
      end
    end
  end
end
