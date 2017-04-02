class Competition < ApplicationRecord
  has_many :user_comps
  has_many :users, through: :user_comps

  # TODO: Validations
  # Must have 2 users
  # Must have start_date, end_date

  def over?
    DateTime.now >= end_date
  end

  def tie?
    sorted = users_by_climb_count
    sorted.all? { |u| u.climbs.count == sorted.first.climbs.count }
  end

  def users_by_climb_count
    users.sort_by { |user| user.climbs.where(climb_date: start_date..end_date).count }.reverse
  end

  def winner
    return nil if tie?
    users_by_climb_count.first
  end
end
