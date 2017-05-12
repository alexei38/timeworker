class TimeReport < ActiveRecord::Base
    belongs_to :user
    before_save :set_start_time

    def self.worked_by_user(user)
        self.end_work_for_user(user)
        self.where(:end_time => nil).where(:user_id => user.id)
    end

    def self.end_work_for_user(user)
        may_by_disable = self.where(:end_time => nil).where(:user_id => user.id)
        may_by_disable.each do |obj|
            max_work_time = obj.start_time.to_date + 72000.second
            if Time.zone.now > max_work_time
                obj.end_time = max_work_time
                obj.save
            end
        end
    end

    private

    def set_start_time
        self.start_time = Time.zone.now
    end
end
