module GitLabBuildOutput
  module CiService
    class Base
      class << self
        attr_reader :subclasses
      end

      def self.inherited(subclass)
        @subclasses ||= Set.new
        subclasses.add(subclass)
      end

      def self.from(repository)
        subclass = subclasses.find { |cls| cls.ci_service?(repository) }
        subclass&.new or raise UnrecognizedError, repository
      end
    end
  end
end
