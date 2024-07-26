class CreateMinas < ActiveRecord::Migration[7.2]
  def change
    create_table :minas do |t|
      t.timestamps
    end
  end
end
