class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable\

  has_many :climbs
  has_many :user_comps
  has_many :competitions, through: :user_comps

  after_create :injest_climbs

  def update_with_latest_climb(climb)
    climb_date = Climb.parse_date_from_mp_format(climb[:date])
    update_attribute(:latest_climb_date, climb_date)
    update_attribute(:latest_climb_route_id, climb[:id])
  end

  def lastest_climb_date_in_mp_format
    latest_climb_date.strftime('%F')
  end

  def latest_climb_compound
    return nil if latest_climb_route_id.nil? || latest_climb_date.nil?
    User.latest_climb_compound(lastest_climb_date_in_mp_format, latest_climb_route_id)
  end

  def self.latest_climb_compound(mp_format_date, route_id)
    "#{mp_format_date}_#{route_id}"
  end

  private

  def injest_climbs
    ClimbInjestionWorker.perform_async(id)
  end
end
