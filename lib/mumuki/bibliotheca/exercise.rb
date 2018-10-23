module Mumuki:Bibliotheca
  class Exercise < Bibliotheca::SchemaDocument
    def initialize(e)
      @guide = e.indifferent_delete(:guide)
      super(e)
      process_kids_states!
    end

    def process_kids_states!
      return unless self.input_kids?
      raise 'Only Gobstones language is currently supported' unless language.gobstones?
      test = GobstonesKidsTest.new(self.tests)
      if test.valid?
        self.initial_state = test.initial_board
        self.final_state = test.final_board
      end
    end

    def errors
      [
        ("Invalid exercise type #{type}" unless [nil, 'problem', 'playground', 'reading', 'interactive'].include? type),
        ('Name must not contain a / character' if name.include? '/'),
        ("Invalid assistance_rules" unless (Mumukit::Assistant.parse assistance_rules.map &:deep_symbolize_keys rescue false)),
        ("Invalid expectations" unless expectations.all? { |it| Mumukit::Inspection::parse(it["inspection"]) rescue false }),
        ("Invalid randomizations" unless randomizations.nil? || (Mumukit::Randomizer.parse randomizations rescue false))
      ].compact
    end
  end
end

class GobstonesKidsTest
  def initialize(spec)
    spec &&= YAML.load(spec)
    @examples = spec&.dig('examples')
    @with_head = spec&.dig('check_head_position')
  end

  def kids_test
    YAML.load(self.test) if self.test
  end

  def to_gs_board(board, with_head)
    "<gs-board#{with_head ? "" : " without-header"}> #{board} </gs-board>" if board
  end

  def boom_board
    "<img src='https://user-images.githubusercontent.com/1631752/37945593-54b482c0-3157-11e8-9f32-bd25d7bf901b.png'>"
  end

  def valid?
    @examples.present?
  end

  def initial_board
    to_gs_board(first_example['initial_board'], true)
  end

  def final_board
    to_gs_board(first_example['final_board'], @with_head) || boom_board
  end

  def first_example
    @examples.first
  end
end
