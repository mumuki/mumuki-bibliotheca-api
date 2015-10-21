module GitIo::Ordering
  def self.from(order)
    order ? GitIo::FixedOrdering.new(order) : GitIo::NaturalOrdering
  end
end

class GitIo::FixedOrdering
  def initialize(order)
    @order = order
  end

  def with_position(original_id, builder)
    builder.position = position_for(original_id)
  end

  def position_for(original_id)
    @order.index(original_id) + 1
  end
end

module GitIo::NaturalOrdering
  def self.with_position(_original_id, _builder)
  end
end
