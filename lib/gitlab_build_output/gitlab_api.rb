module GitLabBuildOutput
  class GitlabApi
    def initialize(endpoint, private_token)
      Gitlab.configure do |config|
        config.endpoint = endpoint
        config.private_token = private_token
      end
    end

    def method_missing(name, *args)
      Gitlab.send(name, *args)
    end
  end
end
