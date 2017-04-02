class Climb < ApplicationRecord
  belongs_to :user

  def self.parse_date_from_mp_format(mp_date)
    date_comps = mp_date.split('-')
    DateTime.new(date_comps[0].to_i, date_comps[1].to_i, date_comps[2].to_i)
  rescue => _
    Rails.logger.error("Failed to parse MP date: #{mp_date}")
    return nil
  end
end
