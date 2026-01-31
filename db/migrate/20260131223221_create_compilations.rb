class CreateCompilations < ActiveRecord::Migration[8.1]
  def change
    create_table :compilations do |t|
      t.references :user, null: false, foreign_key: true
      t.string :input_type
      t.text :input_text
      t.text :output_text
      t.string :language

      t.timestamps
    end
  end
end
