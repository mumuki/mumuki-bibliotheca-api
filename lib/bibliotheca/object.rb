class Object
  def ensure_present!(*args)
    raise 'arguments must be non null' if args.any?(&:blank?)
  end
end