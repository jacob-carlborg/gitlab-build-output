module GitLabBuildOutput
  class LoopRunner < SingleRunner
    def run
      loop do
        status = super
        break if GitLabApi::Status.done?(status)
        sleep interval
      end
    end
  end
end
