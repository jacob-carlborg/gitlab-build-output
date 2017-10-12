module GitLabBuildOutput
  class SingleRunner
    def initialize(job_tracer, outputter, interval)
      @job_tracer = job_tracer
      @outputter = outputter
      @interval = interval
    end

    def run
      trace, status = job_tracer.trace
      outputter.output(trace)
      status
    end

    private

    attr_reader :job_tracer
    attr_reader :outputter
    attr_reader :interval
  end
end
