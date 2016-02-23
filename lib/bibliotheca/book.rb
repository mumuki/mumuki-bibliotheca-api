module Bibliotheca
  class Book < JsonWrapper
    def errors
      [
        ("Name must be present" unless name.present?),
        ("Language must be present" unless language.present?),
        ("Description must be present" unless description.present?)
      ]
    end
  end
end
