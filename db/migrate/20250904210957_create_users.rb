class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name, null: false, limit: 50
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :lasid, null: false, limit: 4

      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index :users, :lasid, unique: true
  end
end
