module Bibliotheca
  class Exercise < Bibliotheca::SchemaDocument
    def initialize(e)
      @guide = e.indifferent_delete(:guide)
      super(e)
      process_choices!
      set_states!
    end

    def schema
      Bibliotheca::Schema::Exercise
    end

    def effective_language_name
      language || @guide.try { |it| it.raw[:language] }
    end

    def text?
      effective_language_name == 'text'
    end

    def process_choices!
      if text?
        multiple_choices_to_test! if multiple_choice?
        single_choices_to_test! if single_choice?
      end
    end

    def multiple_choices_to_test!
      value = choices.each_with_index
                .map { |choice, index| choice.merge('index' => index.to_s) }
                .select { |choice| choice['checked'] }
                .map { |choice| choice['index'] }.join(':')
      self.test = {'equal' => value}.to_yaml
    end

    def single_choices_to_test!
      choice = choices.find { |choice| choice['checked'] }
      self.test = {'equal' => choice['value']}.to_yaml
    end

    def multiple_choice?
      editor == 'multiple_choice'
    end

    def single_choice?
      editor == 'single_choice'
    end

    def markdownified
      self.dup.tap do |exercise|
        exercise.hint = Mumukit::ContentType::Markdown.to_html(exercise.hint)
        exercise.corollary = Mumukit::ContentType::Markdown.to_html(exercise.corollary)
        exercise.description = Mumukit::ContentType::Markdown.to_html(exercise.description)
        exercise.teacher_info = Mumukit::ContentType::Markdown.to_html(exercise.teacher_info)
      end
    end

    def set_states!
      return unless self.kids? && self.test
      raise 'Only Gobstones language is currently supported' unless effective_language_name === 'gobstones'
      examples = YAML.load(self.test)['examples']
      return if examples.blank?
      first_example = examples.first
      self.initial_state = to_gs_board(first_example['initial_board'])
      self.final_state = to_gs_board(first_example['final_board']) || boom_board
    end

    def to_gs_board(board)
      "<gs-board> #{board} </gs-board>" if board
    end

    def boom_board
      "<img src='https://user-images.githubusercontent.com/1631752/37945593-54b482c0-3157-11e8-9f32-bd25d7bf901b.png'>"
    end

    def kids?
      layout == 'input_kids'
    end

    def errors
      [
        ("Invalid layout #{layout}" unless [nil, 'input_right', 'input_bottom', 'input_kids'].include? layout),
        ("Invalid editor #{editor}" unless [nil, 'code', 'custom', 'multiple_choice', 'single_choice', 'hidden', 'text', 'upload'].include? editor),
        ('Name must be present' unless name.present?),
        ('Name must not contain a / character' if name.include? '/'),
        ("Invalid exercise type #{type}" unless [nil, 'problem', 'playground', 'reading', 'interactive'].include? type),
        ('Description must be present' unless description.present?),
        ("Invalid extra_visible flag #{extra_visible}" unless [nil, true, false].include? extra_visible),
        ("Invalid manual_evaluation flag #{manual_evaluation}" unless [nil, true, false].include? manual_evaluation)
      ].compact
    end
  end
end
