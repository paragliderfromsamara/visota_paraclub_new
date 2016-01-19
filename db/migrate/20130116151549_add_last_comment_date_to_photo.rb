class AddLastCommentDateToPhoto < ActiveRecord::Migration
  def change
    add_column :photos, :last_comment_date, :datetime
  end
end
