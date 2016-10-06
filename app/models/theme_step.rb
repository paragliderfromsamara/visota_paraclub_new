class ThemeStep < ActiveRecord::Base
    attr_accessible :theme_id, :user_id, :last_message_id, :last_visit_date
    belongs_to :user
    belongs_to :theme
    def self.get_from_step_table
        users = User.all
        users.each do |u|
            steps = Step.where(part_id: 9, page_id: 1, user_id: u.id)
            #themes = Theme.where(id: steps)
            if !steps.blank?
                steps.each do |s|
                    ThemeStep.create(theme_id: s.entity_id, user_id: u.id, last_visit_date: s.visit_time)
                end
            end
        end
    end
end
