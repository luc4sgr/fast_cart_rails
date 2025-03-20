class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.text :message, null: false
      t.boolean :read, default: false  # <- Adicionamos o valor padrão aqui

      t.timestamps
    end
  end
end
