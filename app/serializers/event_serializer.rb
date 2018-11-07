class EventSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :date, :image_url, :users

  belongs_to :resort
  has_many :user_events
  # has_many :users
  has_many :comments

  def users
    object.users
  end
end
