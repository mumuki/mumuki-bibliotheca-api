def do_migrate!
  Bibliotheca::Collection::Languages.migrate_exercises! do |exercise|
    new_options =
      case exercise.layout
        when :editor_bottom then
          {layout: :input_bottom, editor: :code}
        when :no_editor then
          {layout: :input_bottom, editor: :hidden}
        when :upload then
          {layout: :input_bottom, editor: :upload}
        else
          {layout: :input_right, editor: :code}
      end

    exercise.layout = new_options[:layout]
    exercise.editor = new_options[:editor]

    if exercise.language.name == 'text'
      exercise.editor = :text
    end
  end
end


