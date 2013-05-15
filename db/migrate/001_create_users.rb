class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.column :identity_key, :string
    end
  end
end
