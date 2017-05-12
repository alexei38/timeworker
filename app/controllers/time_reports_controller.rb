class TimeReportsController < ApplicationController

  def index
  end

  def refresh_button
    @worked = false
    if TimeReport.worked_by_user(current_user).any?
      @worked = true
    end
    render layout: false
  end

  def start_work
    unless TimeReport.worked_by_user(current_user).any?
      TimeReport.create(:user_id => current_user.id, :start_time => Time.zone.now)
    end
    redirect_to root_path
  end

  def stop_work
    worked = TimeReport.worked_by_user(current_user)
    if worked.any?
      worked.each do |work|
        work.end_time = Time.zone.now
        work.save
      end
    end
    redirect_to root_path
  end

end
