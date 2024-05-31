# frozen_string_literal: true

module ApplicationHelper
  def format_datetime(datetime)
    datetime.to_formatted_s(:long)
  end

  def format_date(date)
    date.strftime("%d/%m/%Y")
  end
end
