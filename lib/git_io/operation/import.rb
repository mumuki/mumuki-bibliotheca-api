module GitIo::Operation
  class Import
    include GitIo::Operation
    include GitIo::Operation::WithFileReading

    def run!
      log = nil
      with_cloned_repo do |dir|
        log = read_guide! dir
      end
      guide.update_contributors!
      {result: log.to_s, status: :passed}
    end
  end
end