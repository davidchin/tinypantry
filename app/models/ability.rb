class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :search, to: :read

    user ||= User.new

    can :read, [Recipe, Category]
    can :bookmark, Recipe
    can [:create, :show, :update], User, id: user.id

    if user.role?(:admin)
      can :manage, :all
    end
  end
end
