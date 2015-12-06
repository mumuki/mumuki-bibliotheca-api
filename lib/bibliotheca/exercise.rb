module Bibliotheca
  class Exercise < JsonWrapper
    def defaults
      {type: 'problem',
       tag_list: [],
       layout: 'editor_right'}
    end
  end
end