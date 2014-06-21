class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_and_belongs_to_many :roles

  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_recipes, through: :bookmarks, source: :recipe

  def role?(role_symbol)
    roles.find_by(name: role_symbol.to_s.camelize).present?
  end
end
