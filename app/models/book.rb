class Book < ApplicationRecord
  genres_array = %w(fantasy scy-fi horror comedy crime thriler)

  has_many :episodes, dependent: :destroy

  validates :title, presence: true, length: { in: 5..60 }
  validates :description, presence: true
  validates :genre, inclusion: { in: genres_array }
  validates :quote_hover, presence: true, length: { maximum: 140 }
  include AlgoliaSearch




  algoliasearch do
    attribute :title, :description, :genre, :tags, :quote_hover
    searchableAttributes ['title', 'description', 'genre', 'tags', 'quote_hover']
    minWordSizefor1Typo 4
    minWordSizefor2Typos 8
    # To Do: custom ranking (customRanking ['desc(likes_count)'])
  end

  # def genres_array
  #   return genres
  # end

  # private

  # def genres
  #  %w(fantasy scy-fi horror comedy crime thriler)
  # end

end
