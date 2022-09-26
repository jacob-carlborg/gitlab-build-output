module GitLabBuildOutput
  module CiService
    class Gitlab < Base
      def self.ci_service?(repository)
        Dir.glob('.gitlab-ci.{yml,yaml}', base: repository).any?
      end

      def last_job(last_commit)
        client
          .commit_builds(project_name, last_commit, per_page: 10, page: 1)
          .detect do |e|
            e.status != GitLabApi::Status::CREATED &&
              e.status != GitLabApi::Status::MANUAL &&
              e.status != GitLabApi::Status::SKIPPED
          end
      end

      def job_trace(job_id)
        client.job_trace(project_name, job_id)
      end

      private

      def client
        @client ||= GitLabApi.new(endpoint || infer_endpoint, private_token)
      end

      def infer_endpoint
        uri = URI.parse(parsed_url.host)
        uri.path = '/api/v3'
        uri.host = parsed_url.host
        uri.scheme ||= parsed_url.scheme || scheme
        uri.scheme = scheme if uri.scheme == 'ssh'
        uri.to_s
      end

      def git
        @git ||= Git.open(repository)
      end

      def git_url
        @git_url ||= git.remote.url
      end

      def parsed_url
        @parsed_url ||= GitCloneUrl.parse(git_url)
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
    end
  end
end
