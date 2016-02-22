module Bibliotheca
  class Exercise < JsonWrapper
    def defaults
      {type: 'problem',
       tag_list: [],
       extra_visible: false,
       layout: 'editor_right',
       expectations: []}
    end

    def errors
      [
        ("Invalid layout #{layout}" unless [nil, 'editor_right', 'editor_bottom', 'no_editor'].include? layout),
        ('Name must be present' unless name.present?),
        ('Name must not contain a / character' if name.include? '/'),
        ("Invalid exercise type #{type}" unless [nil, 'problem', 'playground'].include? type),
        ('Description must be present' unless description.present?),
        ("Invalid extra_visible flag #{extra_visible}" unless [nil, true, false].include? extra_visible)
      ].compact
    end
  end
end
