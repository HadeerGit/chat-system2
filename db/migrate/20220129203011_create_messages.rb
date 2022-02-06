class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.integer :identifier, null: false
      t.references :chat,  null: false, foreign_key: true
      t.string :body, null: false
      t.timestamps
    end
    add_index :chats,  [:chat_id, :identifier] ,  unique: true
  end
end
