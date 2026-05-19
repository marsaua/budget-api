class Transaction < ApplicationRecord
  CATEGORIES = %w[food transport home household clubs kids clothes health fun gifts income other].freeze
  KINDS = %w[income expense].freeze

  belongs_to :room
  belongs_to :author, class_name: "User"

  validates :description, presence: true
  validates :amount, numericality: { greater_than: 0 }
  validates :kind, inclusion: { in: KINDS }
  validates :category, inclusion: { in: CATEGORIES }
  validates :occurred_on, presence: true

  scope :for_month, ->(year, month) {
    where(occurred_on: Date.new(year, month, 1)..Date.new(year, month, -1))
  }
  scope :by_date, -> { order(occurred_on: :desc, created_at: :desc) }
end
