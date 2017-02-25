class Competition < ApplicationRecord
  has_many :user_comps
  has_many :users, through: :user_comps
end
