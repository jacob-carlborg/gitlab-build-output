module GitLabBuildOutput
  class JobTracer
    def initialize(private_token, git_repository, endpoint = nil, https: false)
      @https = https
      @tracer = Tracer.new
      @git = Git.open(git_repository)
      self.endpoint = endpoint
      @gitlab = GitLabApi.new(self.send(:endpoint), private_token)
    end

    def trace
      last_job = send(:last_job)
      trace = tracer.next_trace(job_trace(last_job.id))
      [trace, last_job.status]
    end

    def last_job
      gitlab
        .commit_builds(project_name, last_commit, per_page: 10, page: 1)
        .detect do |e|
          e.status != GitLabApi::Status::CREATED &&
            e.status != GitLabApi::Status::MANUAL &&
            e.status != GitLabApi::Status::SKIPPED
        end
    end

    def last_commit
      @last_commit ||= git.log[0].sha
    end

    private

    attr_reader :git
    attr_reader :gitlab
    attr_reader :tracer
    attr_reader :https
    attr_reader :endpoint

    def endpoint=(endpoint)
      return @endpoint = endpoint if endpoint.present?
      uri = URI.parse(parsed_url.host)
      uri.path = '/api/v3'
      uri.host = parsed_url.host
      uri.scheme ||= parsed_url.scheme || scheme
      uri.scheme = scheme if uri.scheme == 'ssh'

      @endpoint = uri.to_s
    end

    def scheme
      @scheme ||= https ? 'https' : 'http'
    end

    def project_name
      @project_name ||= begin
        path = parsed_url.path.gsub(/\A\/+/, '')
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
