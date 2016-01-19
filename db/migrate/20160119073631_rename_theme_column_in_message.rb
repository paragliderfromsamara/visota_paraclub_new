class RenameThemeColumnInMessage < ActiveRecord::Migration
  def change
    change_table :messages do |t|
      t.rename :theme, :name
    end
  end
end
