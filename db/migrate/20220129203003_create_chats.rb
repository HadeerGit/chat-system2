class CreateChats < ActiveRecord::Migration[5.2]
  def change
    create_table :chats do |t|
      t.integer :identifier, null: false
      t.string :name, :limit => 255
      t.references :application, null: false,  foreign_key: true
      t.integer :messages_count, default: 0
      t.timestamps
    end
    add_index :chats,  [:application_id, :identifier] ,  unique: true
  end
end
