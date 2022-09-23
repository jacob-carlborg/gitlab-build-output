module GitLabBuildOutput
  module CiService
    class GithubActions < Base
      def self.ci_service?(repository)
        path = repository.join('.github', 'workflows')
        Dir.glob('*.{yml,yaml}', base: path).any?
      end
    end
  end
end
