def do_migrate!
  Bibliotheca::Collection::Guides.migrate_exercises! do |exercise, guide|
    puts "migrating #{guide.name}/#{exercise.name}..."
    new_options =
      case exercise.layout
        when 'editor_right'
          {layout: 'input_right', editor: 'code'}
        when 'editor_bottom' then
          {layout: 'input_bottom', editor: 'code'}
        when 'no_editor' then
          {layout: 'input_bottom', editor: 'hidden'}
        when 'upload' then
          {layout: 'input_bottom', editor: 'upload'}
        else
          nil
      end

    new_options.try do
      exercise.layout = new_options[:layout]
      exercise.editor = new_options[:editor]

      if exercise.effective_language_name(guide) == 'text'
        exercise.editor = 'text'
      end
      puts '...updated!'
    end
  end
end


