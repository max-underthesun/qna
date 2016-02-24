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
    can [:update, :destroy], [Question, Answer], user_id: user.id
    can :destroy, Attachment, attachable: { user_id: user.id }

    can_manage_votes
    can_choose_best_answer
    can_get_profiles

    can :create, Subscription
    can :destroy, Subscription, user_id: user.id
  end

  def can_manage_votes
    can [:vote_up, :vote_down], [Question, Answer] { |votable| !user.author_of?(votable) }
    can :vote_destroy, [Question, Answer] do |votable|
      votable.votes.find_by(user: user)
    end
  end

  def can_choose_best_answer
    can :best, Answer do |answer|
      user.author_of?(answer.question)
    end
  end

  def can_get_profiles
    can :me, User, id: user.id
    can :all_except_current, User, id: user.id
  end
end
