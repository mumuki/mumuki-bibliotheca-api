class Git::Lib
  # Monkey patch to add --ignore-unmatch option
  def remove(path = '.', opts = {})
    arr_opts = %w(-f --ignore-unmatch)
    arr_opts << ['-r'] if opts[:recursive]
    arr_opts << '--'
    if path.is_a?(Array)
      arr_opts += path
    else
      arr_opts << path
    end
    command('rm', arr_opts)
  end
end