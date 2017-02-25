class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable\

  has_many :climbs
  has_many :user_comps
  has_many :competitions, through: :user_comps

  after_create :injest_climbs

  private

  def injest_climbs
    ClimbInjestionWorker.perform_async(self.id)
  end
end
