class ClimbInjestionWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    puts user
  end
end
