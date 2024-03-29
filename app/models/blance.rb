class Blance < ApplicationRecord
  has_one :history_order, dependent: :destroy
  has_many :histories, dependent: :destroy

  has_many_attached :images

  default_scope -> { order(date: :desc) }

  validates :date, presence: true
  validates :category, length: { maximum: 100 }
  validates :rate, numericality: { less_than: 2**10, allow_nil: true }
  validates :images, content_type: [:png, :jpg, :jpeg], size: { less_than: 16.megabytes }

  # validates :machine_name, :store, :note
  with_options length: { maximum: 1000 } do
    validates :machine_name
    validates :store
    validates :note
  end

  # validates :investment_money, :recovery_money, :investment_saving, :recovery_saving
  with_options numericality: { less_than: 2**31, allow_nil: true } do
    validates :investment_money
    validates :recovery_money
    validates :investment_saving
    validates :recovery_saving
  end

  def result
    investment_money = self.investment_money.to_i
    recovery_money = self.recovery_money.to_i
    rate = self.rate.to_f
    investment_saving = self.investment_saving.to_i * rate
    recovery_saving = self.recovery_saving.to_i * rate
    result = recovery_money - investment_money + recovery_saving - investment_saving
    result.round
  end

  def total_investment_money
    investment_money = self.investment_money.to_i
    rate = self.rate.to_f
    investment_saving = self.investment_saving.to_i * rate
    (investment_money + investment_saving).round
  end

  def total_recovery_money
    recovery_money = self.recovery_money.to_i
    rate = self.rate.to_f
    recovery_saving = self.recovery_saving.to_i * rate
    (recovery_money + recovery_saving).round
  end

  def sort_histories
    return histories if history_order.order.blank?

    order_array = history_order.order.split(',').map(&:to_i)
    histories.sort_by { |history| order_array.index(history.id) || 9999 }
  end
end
