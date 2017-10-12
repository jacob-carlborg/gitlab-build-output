module GitLabBuildOutput
  class JobTracer
    def initialize(endpoint, private_token, git_repository)
      @git_repository = git_repository
      @git = Git.open(git_repository)
      @gitlab = GitLabApi.new(endpoint, private_token)
      @tracer = Tracer.new
    end

    def trace
      last_job = send(:last_job)
      trace = tracer.next_trace(job_trace(last_job.id))
      [trace, last_job.status]
    end

    private

    attr_reader :git
    attr_reader :gitlab
    attr_reader :tracer

    def last_commit
      @last_commit ||= git.log[0].sha
    end

    def last_job
      gitlab
        .commit_builds(project_name, last_commit, per_page: 10, page: 1)
        .detect do |e|
          e.status != GitLabApi::Status::CREATED &&
            e.status != GitLabApi::Status::MANUAL
        end
    end

    def project_name
      @project_name ||= begin
        path = parsed_url.path
        File.join(File.dirname(path), File.basename(path, File.extname(path)))
      end
    end

    def git_url
      @git_url ||= git.remote.url
    end

    def parsed_url
      @parsed_url ||= GitCloneUrl.parse(git_url)
    end

    def job_trace(job_id)
      gitlab.job_trace(project_name, job_id)
    end
  end
end
