class CreateAdminLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :admin_logs do |t|
      t.references :admin, null: false, foreign_key: { to_table: :users }
      t.string :action, null: false
      t.text :details, null: false

      t.timestamps
    end
  end
end
