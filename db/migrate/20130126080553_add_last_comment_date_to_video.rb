class AddLastCommentDateToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :last_comment_date, :datetime
  end
end
