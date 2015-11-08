module GitIo::Operation
  class Import < GitIo::Operation::Operation
    def run_in_local_repo(dir, repo, local_repo)
      @guide = GuideReader.new(dir, repo, log).read_guide!
    end

    def postprocess
      id = {id: find_id}
      db.update_one(guide_query, @guide.as_json.merge(id), {upsert: true})
      db.find(id).first
    end

    private

    def find_id
      db.find(guide_query).try(:first).try(:id) || IdGenerator.next
    end

    def guide_query
      {github_repository: @guide.github_repository}
    end
  end
end