class CalculateReputationJob < ActiveJob::Base
  queue_as :default

  def perform(object)
    # Do something later
    reputation = Reputation.calculate(object)
    object.user.update(reputation: reputation)
  end
end
