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
    can :update, [Question, Answer], user_id: user.id
    can :destroy, [Question, Answer], user_id: user.id
    can :vote_up, [Question, Answer] { |votable| !user.author_of?(votable) }
    can :vote_down, [Question, Answer] { |votable| !user.author_of?(votable) }

    can :vote_destroy, [Question, Answer] do |votable|
      votable.votes.find_by(user: user)
    end

    can :best, Answer do |answer|
      user.author_of?(answer.question)
    end

    can :destroy, Attachment, attachable: { user_id: user.id }
  end
end
