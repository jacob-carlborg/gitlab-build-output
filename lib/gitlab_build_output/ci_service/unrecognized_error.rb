module GitLabBuildOutput
  module CiService
    class UnrecognizedError < RuntimeError
      attr_reader :path

      def initialize(path)
        @path = path
      end
    end
  end
end
