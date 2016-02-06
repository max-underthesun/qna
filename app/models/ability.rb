class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer], user: user
    can :destroy, [Question, Answer], user: user
    can :vote_up, [Question, Answer] { |votable| !user.author_of?(votable) }
    can :vote_down, [Question, Answer] { |votable| !user.author_of?(votable) }

    can :vote_destroy, [Question, Answer] do |votable|
      votable.votes.find_by(user: user)
    end

    can :best, Answer do |answer|
      user.author_of?(answer.question)
      # answer.question.user == user
    end

    can :destroy, Attachment, attachable: { user_id: user.id }

    # can :vote_destroy, [Question] { |question| true if question.votes.find_by(user: @user) }

    # can :destroy, Vote, user: user
    # can :destroy, [Vote] { |vote| user.author_of?(vote) }

    #   # Vote.exists?(user: @user, votable: votable)
    #   # votable.votes.find_by(user: @user) #.persisted?
    #   # @user.author_of?(vote)

    # can :best, Answer, question: { user: user }
    # can :best, [Answer] { |answer| user.author_of?(answer.question) }


    # can :destroy, [Attachment] { |attachment| user.author_of?(attachment.attachable) }
    # cannot :destroy, [Attachment] { |attachment| !user.author_of?(attachment.attachable) }

    # can :destroy, [Attachment], question: { user: user }
    # can :destroy, [Attachment], answer: { user: user }
    # can :manage, [Attachment], attachable: { user: user }

    # can :destroy, Attachment do |attachment|
    #   # user.author_of?(attachment.attachable)
    #   # attachment.attachable.user == user
    #   attachment.attachable.user_id == user.id
    # end
 
    # cannot :destroy, Attachment do |attachment|
    #   # user.author_of?(attachment.attachable)
    #   # attachment.attachable.user == user
    #   attachment.attachable.user_id != user.id
    # end
  end
end
