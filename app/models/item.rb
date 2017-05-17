class Item < ActiveRecord::Base
  belongs_to :category
  has_many :line_items

  def self.available_items
    sql = <<-sql
      inventory > ?
    sql

    self.where(sql, 0)
  end
end
