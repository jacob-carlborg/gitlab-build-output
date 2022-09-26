module GitLabBuildOutput
  class GitHuApi
    class Status
      CREATED = 'created'.freeze
      PENDING = 'pending'.freeze
      RUNNING = 'running'.freeze
      FAILED = 'failed'.freeze
      SUCCESS = 'success'.freeze
      CANCELED = 'canceled'.freeze
      SKIPPED = 'skipped'.freeze
      MANUAL = 'manual'.freeze

      def self.done?(status)
        case status
        when FAILED, SUCCESS, CANCELED, SKIPPED
          true
        else
          false
        end
      end
    end

    def initialize(endpoint, private_token)
      @client ||=
        Gitlab.client(endpoint: endpoint, private_token: private_token)
    end

    def method_missing(method, *args, &block)
      if @client.respond_to?(method)
        @client.public_send(method, *args, &block)
      else
        super
      end
    end

    def respond_to_missing?(*args)
      @client.respond_to_missing(*args)
    end

    # def job_trace(project, job_id)
    #   options = {}
    #   @client.send(:set_authorization_header, options)
    #   url = @client.endpoint +
    #     "/projects/#{@client.url_encode(project)}/builds/#{id}/trace"
    #   @client.validate HTTParty.get(url, options)
    # end
  end
end
