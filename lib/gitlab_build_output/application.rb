module GitLabBuildOutput
  # rubocop:disable Metrics/ClassLength
  class Application
    attr_reader :raw_args
    attr_reader :args
    attr_reader :option_parser

    Args = Struct.new(
      :help, :verbose, :version, :private_token, :endpoint, :loop
    )

    def initialize(raw_args)
      @raw_args = raw_args
      @args = Args.new
    end

    def self.start
      new(ARGV).run
    end

    def run
      parse_verbose_argument(raw_args, args)
      handle_errors do
        @option_parser = parse_arguments(raw_args, args)
        exit = handle_arguments(args)
        return if exit
        runner.run
      end
    end

    private

    def runner
      @runner ||=
        (args.loop ? LoopRunner : SingleRunner).new(job_tracer, outputter, 0.5)
    end

    def job_tracer
      @job_tracer ||= JobTracer.new(
        args.endpoint, args.private_token, git_repository
      )
    end

    def outputter
      @outputter ||= Outputter.new
    end

    def git_repository
      raw_args.first
    end

    def error_handler
      args.verbose ? :verbose_error_handler : :default_error_handler
    end

    def handle_errors(&block)
      send(error_handler, &block)
    end

    def default_error_handler(&block)
      verbose_error_handler(&block)
    rescue OptionParser::InvalidArgument => e
      args = e.args.join(' ')
      puts "Invalid argument: #{args}"
      exit 1
      # rubocop:disable Lint/RescueException
    rescue Exception => e
      # rubocop:enable Lint/RescueException
      puts "An unexpected error occurred: #{e.message}"
      exit 1
    end

    def verbose_error_handler
      yield
    end

    def valid_formats_description
      @valid_formats_description ||= begin
        list = VALID_FORMATS.join(', ')
        "(#{list})"
      end
    end

    def parse_verbose_argument(raw_args, args)
      args.verbose = raw_args.include?('-v') || raw_args.include?('--verbose')
    end

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    def parse_arguments(raw_args, args)
      opts = OptionParser.new
      opts.banner = banner
      opts.separator ''
      opts.separator 'Options:'

      opts.on('-e', '--endpoint <endpoint>', 'The GitLab endpoint') do |e|
        args.endpoint = e
      end

      opts.on('-p', '--private_token <private_token>', 'The private token ' \
        'used to authenticate to GitLab') do |value|
        args.private_token = value
      end

      opts.on('-l', '--[no-]loop', 'Loop until the job is complete') do |value|
        args.loop = value
      end

      opts.on('-v', '--[no-]verbose', 'Show verbose output') do |value|
        args.verbose = value
      end

      opts.on('--version', 'Print version information and exit') do
        args.version = true
        puts GitLabBuildOutput::VERSION
      end

      opts.on('-h', '--help', 'Show this message and exit') do
        args.help = true
        print_usage
      end

      opts.separator ''
      opts.separator "Use the `-h' flag for help."

      opts.parse!(raw_args)
      opts
    end
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/MethodLength

    def handle_arguments(args)
      if git_repository.nil?
        print_usage
        true
      else
        args.help || args.version
      end
    end

    def banner
      @banner ||= "Usage: gitlab-build-output [options] <git_repository>\n" \
        "Version: #{GitLabBuildOutput::VERSION}"
    end

    def print_usage
      puts option_parser.to_s
    end
  end
  # rubocop:enable Metrics/ClassLength
end
