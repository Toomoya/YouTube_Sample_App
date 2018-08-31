class Youtube < ApplicationRecord
  validates :artist, presence: true
  validates :song, presence: true
end
