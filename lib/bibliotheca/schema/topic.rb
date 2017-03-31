module Bibliotheca::Schema::Topic
  extend Bibliotheca::Schema

  def self.fields_schema
    [
      {name: :id},
      {name: :slug},

      {name: :name},
      {name: :locale},
      {name: :appendix},
      {name: :description},
      {name: :teacher_info},

      {name: :lessons}
    ]
  end
end
