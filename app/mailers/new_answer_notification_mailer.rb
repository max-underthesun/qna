class NewAnswerNotificationMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.new_answer_notification_mailer.notify_question_author.subject
  #
  def notify_question_author(answer)
    question_author = answer.question.user
    @greeting = "Hi #{question_author.email}!"
    @question = answer.question
    @answer = answer

    mail to: question_author.email
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.new_answer_notification_mailer.notify_subscribers.subject
  #
  def notify_subscribers(answer, subscriber)
    @greeting = "Hi #{subscriber.email}!"
    @question = answer.question
    @answer = answer

    mail to: subscriber.email
  end
end
