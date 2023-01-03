class CreateFriendships < ActiveRecord::Migration[7.0]
  def change
    create_table :friendships, id:false do |t|
      t.integer :id_user_1
      t.integer :id_user_2
      t.string :status
      t.timestamps
    end

    reversible do | dir |
      dir.up do
        execute "ALTER TABLE #{:friendships} ADD PRIMARY KEY (id_user_1,id_user_2);"
      end
    end
  end
end
