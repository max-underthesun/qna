# Preview all emails at http://localhost:3000/rails/mailers/new_answer_notification_mailer
class NewAnswerNotificationMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/new_answer_notification_mailer/notify_question_author
  def notify_question_author
    NewAnswerNotificationMailer.notify_question_author
  end

  # Preview this email at http://localhost:3000/rails/mailers/new_answer_notification_mailer/notify_subscribers
  def notify_subscribers
    NewAnswerNotificationMailer.notify_subscribers
  end

end
