class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :trackable, :validatable

    has_many :time_reports
    before_save :save_group

    def email_required?
      false
    end

    def email_changed?
      false
    end

    def admin?
      return self.admin
    end

    def worked
      TimeReport.worked_by_user(self)
    end

    def worked?
      self.worked.any?
    end

    def hours_in_day(day)
      start_time = day.to_time.in_time_zone.beginning_of_day
      end_time = day.to_time.in_time_zone.end_of_day
      TimeReport.end_work_for_user(self)
      reports = self.time_reports.where("start_time >= ? and end_time <= ?", start_time, end_time)
      hours = 0
      reports.each do |report|
        end_time_report = report.end_time
        if end_time_report.nil?
          end_time_report = Time.zone.now
        end
        hours += (end_time_report.hour - report.start_time.hour).to_i
      end
      hours.to_s
    end

    private

    def save_group
      if self.new_record?
        if User.count == 0
          self.admin = true
        end
      end
    end
end
