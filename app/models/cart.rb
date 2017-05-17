class Cart < ActiveRecord::Base
  belongs_to :user

  has_many :line_items
  has_many :items, through: :line_items

  def total
    total = 0
    self.line_items.each do |li|
      total += li.item.price * li.quantity
    end
    total
  end

  def add_item(item_id)
    line_item = self.line_items.find_by(item_id: item_id)
    if line_item
      line_item.quantity += 1
    else
      line_item=self.line_items.build(item_id: item_id)
    end
    line_item
  end

  def checkout
    self.update(status: 'checked out')
    change_inventory
  end

  def change_inventory
    self.line_items.each do |li|
      item = Item.find_by(id: li.item_id)
      item.update(inventory: item.inventory - li.quantity)
    end
  end
end
