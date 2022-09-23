module GitLabBuildOutput
  module CiService
    class Gitlab < Base
      def self.ci_service?(repository)
        Dir.glob('.gitlab-ci.{yml,yaml}', base: repository).any?
      end
    end
  end
end
