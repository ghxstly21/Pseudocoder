class AddInstructionsToCompilations < ActiveRecord::Migration[8.1]
  def change
    add_column :compilations, :instructions, :text
  end
end
