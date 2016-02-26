class NotifyingSubscribersJob < ActiveJob::Base
  queue_as :default

  def perform(answer)
    answer.question.subscribers.find_each.each do |subscriber|
      NewAnswerNotificationMailer.notify_subscribers(answer, subscriber).deliver_later
    end
  end
end
