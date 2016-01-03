module Bibliotheca
  class Exercise < JsonWrapper
    def defaults
      {type: 'problem',
       tag_list: [],
       layout: 'editor_right'}
    end

    def errors
      [
        ("Invalid layout #{layout}" unless ['editor_right', 'editor_bottom', 'no_editor'].include? layout),
        ('Name must be present' unless name.present?),
        ('Name must not contain a \ character' if name.include? '/'),
        ("Invalid exercise type #{type}" unless ['problem', 'playground'].include? type)
      ].compact
    end
  end
end