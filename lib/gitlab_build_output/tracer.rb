module GitLabBuildOutput
  class Tracer
    def initialize
      @previous_trace = ''
    end

    def next_trace(trace)
      new_trace = diff(previous_trace, trace)
      return '' if new_trace.nil?
      previous_trace << new_trace
      new_trace
    end

    private

    attr_reader :previous_trace

    def diff(s1, s2)
      s1 ||= ''
      s2 ||= ''

      return '' if s1 == s2
      index = s2.chars.zip(s1.chars).index { |a, b| a != b }
      return nil if index.nil?
      s2[index..-1]
    end
  end
end
