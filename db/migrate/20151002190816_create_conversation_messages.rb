class CreateConversationMessages < ActiveRecord::Migration
  def change
    create_table :conversation_messages do |t|
      t.integer :conversation_id
      t.integer :message_id
      t.timestamps null: false
    end
  end
end
