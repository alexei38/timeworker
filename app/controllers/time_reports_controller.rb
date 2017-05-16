class TimeReportsController < ApplicationController

  def index
  end

  def refresh_button
    @worked = false
    if current_user.worked?
      @worked = true
    end
    render layout: false
  end

  def start_work
    unless current_user.worked?
      TimeReport.create(:user_id => current_user.id, :start_time => Time.zone.now)
    end
    redirect_to root_path
  end

  def stop_work
    if current_user.worked.any?
      current_user.worked.each do |work|
        work.end_time = Time.zone.now
        work.save
      end
    end
    redirect_to root_path
  end

end
