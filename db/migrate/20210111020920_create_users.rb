class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :id
      t.string :name
      t.string :email

      t.timestamps
    end
  end
end
