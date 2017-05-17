class AdminController < ApplicationController

  before_filter :need_admin

  MONTHS = [["Январь", "1"],
               ["Февраль", "2"],
               ["Март", "3"],
               ["Апрель", "4"],
               ["Май", "5"],
               ["Июнь", "6"],
               ["Июль", "7"],
               ["Август", "8"],
               ["Сентябрь", "9"],
               ["Октябрь", "10"],
               ["Ноябрь", "11"],
               ["Декабрь", "12"],
    ]

  def index
    @months = MONTHS
    @current_year = Time.now.year
    start_time = TimeReport.all.pluck(:start_time).min
    if start_time
      min_year = start_time.year
    else
      min_year = @current_year
    end
    @current_month = Time.now.month
    @years = (min_year..@current_year).to_a.uniq
    @users = User.all.sort_by(&:fio)
  end

  def edit
    @user = User.find_by_id(params[:id])
    if @user.id == current_user.id
      redirect_to :controller => 'devise/registrations', :action => 'edit', :id => @user
    end
  end

  def update
    @user = User.find_by_id(params[:id])
    if @user.id == current_user.id
      redirect_to :controller => 'devise/registrations', :action => 'edit', :id => @user
    end
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
      save = @user.update_without_password(user_params)
    else
      save = @user.update(user_params)
    end
    if save
      redirect_to :action => :index
    else
      render 'edit'
    end
  end

  def report
    @users = User.all.sort_by(&:fio)
    param_date = Date.parse(params[:date])
    @start_date = param_date.beginning_of_day.to_date
    @end_date = param_date.end_of_month.to_date

    dir_name = Rails.root.join('tmp', 'reports')
    if !Dir::exist?(dir_name)
      Dir::mkdir(dir_name)
    end

    alphabet = [('a'..'z'), ('A'..'Z'), (0..9)].map { |i| i.to_a }.flatten
    file_name = (0...25).map { alphabet[rand(alphabet.length)] }.join
    file_name = "#{file_name}.xls"
    full_path = Rails.root.join(dir_name, file_name).to_s

    workbook = WriteExcel.new(full_path)

    format_project = workbook.add_format
    format_project.set_font('Cambria')

    format_work = workbook.add_format
    format_work.set_align('center')
    format_work.set_text_wrap()
    format_work.set_font('Cambria')
    format_work.set_size(8)
    format_work.set_border(1)

    format_notwork = workbook.add_format
    format_notwork.set_align('center')
    format_notwork.set_text_wrap()
    format_notwork.set_font('Cambria')
    format_notwork.set_size(8)
    format_notwork.set_border(1)
    format_notwork.set_bg_color('green')

    format_th = workbook.add_format
    format_th.set_align('center')
    format_th.set_bold
    format_th.set_font('Cambria')
    format_th.set_size(9)
    format_th.set_border(2)


    format_header = workbook.add_format
    format_header.set_align('center')
    format_header.set_bold
    format_header.set_font('Cambria')
    format_header.set_size(12)

    worksheet  = workbook.add_worksheet("Страница 1")

    worksheet.set_column('A:A', 4) #id
    worksheet.set_column('B:B', 40) #fio
    worksheet.set_column('C:EZ', 4) #hours and days

    month_text = MONTHS.select{|month, num| month if num.to_i == param_date.month}[0][0]
    worksheet.set_row(0, 20)
    worksheet.set_row(1, 20)
    worksheet.set_row(2, 20)
    
    worksheet.write(0, 12, 'ООО "Регион-Строй"', format_header)
    worksheet.write(1, 12, "ТАБЕЛЬ УЧЕТА РАБОЧЕГО ВРЕМЕНИ", format_header)
    worksheet.write(2, 12, "за #{month_text} #{param_date.year} год", format_header)

    skip_row = 3
    skip_col = 0
    col_id = 2
    (@start_date..@end_date).each do |day|
      worksheet.write(skip_row, skip_col + col_id, day.day, format_th)
      col_id += 1
    end

    row_id = 1
    worksheet.write(skip_row, skip_col, "№", format_th)
    worksheet.write(skip_row, skip_col + 1, "Фамилия", format_th)
    @users.each do |user|
      worksheet.write(row_id + skip_row, skip_col, user.id, format_work)
      worksheet.write(row_id + skip_row, skip_col + 1, user.fio, format_work)
      col_id = 2
      (@start_date..@end_date).each do |day|
        if day.wday.to_i.in? [6, 0]
          fmt = format_notwork
        else
          fmt = format_work
        end
        hours = user.hours_in_day(day)
        if hours > 0
          worksheet.write(row_id + skip_row, skip_col + col_id, hours, fmt)
        else
          worksheet.write(row_id + skip_row, skip_col + col_id, "", fmt)
        end
        col_id += 1
      end
      row_id += 1
    end

    workbook.close
    send_file Rails.root.join(dir_name, file_name), :filename => 'report.xlsx', :type => "application/xlsx"
  end

  private

  def need_admin
    unless current_user.admin?
      render text: "Code 403. Ошибка доступа", status: :forbidden
    end
  end

  def user_params
    params.require(:user).permit(:username, :fio, :admin, :password, :password_confirmation, :current_password)
  end

end
