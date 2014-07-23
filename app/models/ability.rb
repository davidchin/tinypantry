class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :search, to: :read

    user ||= User.new

    can :read, [Recipe, Category]
    can [:read, :recipes], Bookmark
    can [:create, :destroy], Bookmark, user_id: user.id
    can [:create, :show, :update], User, id: user.id

    can :manage, :all if user.role?(:admin)
  end
end
