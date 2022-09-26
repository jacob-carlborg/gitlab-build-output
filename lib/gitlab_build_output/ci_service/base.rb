module GitLabBuildOutput
  module CiService
    class Base
      class << self
        attr_reader :subclasses
      end

      attr_reader :private_token
      attr_reader :repository
      attr_reader :endpoint
      attr_reader :https

      def initialize(private_token, repository, endpoint = nil, https: false)
        @private_token = private_token
        @repository = repository
        @endpoint = endpoint
        @https = https
      end

      def self.inherited(subclass)
        @subclasses ||= Set.new
        subclasses.add(subclass)
      end

      def self.from(private_token:, repository:, endpoint: nil, https: false)
        subclass = subclasses.find { |cls| cls.ci_service?(repository) }
        raise UnrecognizedError, repository unless subclass
        subclass.new(private_token, repository, endpoint, https: https)
      end
    end
  end
end
