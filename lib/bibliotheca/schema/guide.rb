module Bibliotheca::Schema::Guide
  extend Bibliotheca::Schema

  def self.fields_schema
    [
      {name: :exercises},
      {name: :id},
      {name: :slug},

      {name: :name},
      {name: :locale},
      {name: :type, default: 'practice'},
      {name: :teacher_info},
      {name: :language},
      {name: :order},
      {name: :beta, default: false},
      {name: :id_format, default: '%05d'},

      {name: :expectations, default: []},
      {name: :description},
      {name: :corollary},
      {name: :extra},
      {name: :AUTHORS, reverse: :authors},
      {name: :COLLABORATORS, reverse: :collaborators}
    ]
  end
end
