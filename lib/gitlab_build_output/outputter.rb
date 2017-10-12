module GitLabBuildOutput
  class Outputter
    def initialize(endpoint, private_token, git_repository)
      @endpoint = endpoint
      @private_token = private_token
      @git_repository = git_repository
    end

    def run
      p 'running'
    end
  end
end
