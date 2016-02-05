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
    can :update, [Question, Answer], user: @user
    can :destroy, [Question, Answer], user: @user
    can :vote_up, [Question, Answer] { |votable| !@user.author_of?(votable) }
    can :vote_down, [Question, Answer] { |votable| !@user.author_of?(votable) }

    # can :vote_destroy, [Question, Answer] do |votable|
    #   votable.votes.find_by(user: @user)
    # end

    can :destroy, Vote, user: @user

    # can :vote_destroy, [Question, Answer] do |votable|
    #   true if votable.votes.find_by(user: @user)
    #   #   true
    #   # else
    #   #   false
    #   # end
    #   # @user.author_of?(vote)
    # end

    # cannot :vote_destroy, [Question, Answer] { |votable| true if votable.votes.find_by(user: @user).nil? }

    # cannot :vote_destroy, [Question, Answer] { |votable| votable.votes.find_by(user: @user).nil? }
    #  do |votable|
    #   # Vote.exists?(user: @user, votable: votable)
    #   # votable.votes.find_by(user: @user) #.persisted?
    #   # @user.author_of?(vote)
    # end
  end
end
