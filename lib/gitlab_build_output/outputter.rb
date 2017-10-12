module GitLabBuildOutput
  class Outputter
    def output(trace)
      puts trace unless trace.empty?
    end
  end
end
