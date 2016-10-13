module Bibliotheca
  class Exercise < Bibliotheca::SchemaDocument
    attr_accessor :guide

    def initialize(json)
      @guide = json.delete(:guide)
      super(json)
    end

    def schema
      Bibliotheca::Schema::Exercise
    end

    def effective_language
      language.try { |it| Bibliotheca::Collection::Languages.find_by(name: it) } || guide.language
    end

    def errors
      [
        ("Invalid layout #{layout}" unless [nil, 'input_right', 'input_bottom'].include? layout),
        ("Invalid editor #{editor}" unless [nil, 'code', 'multiple_choice', 'single_choice', 'hidden', 'text'].include? editor),
        ('Name must be present' unless name.present?),
        ('Name must not contain a / character' if name.include? '/'),
        ("Invalid exercise type #{type}" unless [nil, 'problem', 'playground'].include? type),
        ('Description must be present' unless description.present?),
        ("Invalid extra_visible flag #{extra_visible}" unless [nil, true, false].include? extra_visible),
        ("Invalid manual_evaluation flag #{manual_evaluation}" unless [nil, true, false].include? manual_evaluation)
      ].compact
    end
  end
end
