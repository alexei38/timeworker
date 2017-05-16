class CreateTimeReports < ActiveRecord::Migration
  def change
    create_table :time_reports do |t|
      t.integer  :user_id, :null => false
      t.datetime :start_time
      t.datetime :end_time
    end
    add_index :time_reports, :start_time, :unique => false
    add_index :time_reports, :end_time, :unique => false
    add_index :time_reports, [:start_time, :end_time], :unique => false
    add_index :time_reports, [:user_id, :start_time, :end_time], :unique => true
  end
end
