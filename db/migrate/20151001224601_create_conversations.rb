class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.integer :started_by
      t.timestamps null: false
    end
  end
end
