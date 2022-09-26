module GitLabBuildOutput
  class JobTracer
    def initialize(ci_service)
      @tracer = Tracer.new
      @ci_service = ci_service
    end

    def trace
      last_job = ci_service.last_job(last_commit)
      trace = tracer.next_trace(job_trace(last_job.id))
      [trace, last_job.status]
    end

    private

    attr_reader :ci_service
    attr_reader :tracer

    def git
      @git ||= Git.open(ci_service.repository)
    end

    def last_commit
      @last_commit ||= git.log[0].sha
    end
  end
end
