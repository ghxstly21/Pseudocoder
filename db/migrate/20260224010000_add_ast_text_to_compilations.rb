
class AddAstTextToCompilations < ActiveRecord::Migration[8.1]
  def change
    add_column :compilations, :ast_text, :text
  end
end
