module GitLabBuildOutput
  class HtmlOutputter
    def output(trace)
      puts ansi_to_html(trace) unless trace.empty?
    end

    def ansi_to_html(string)
      Ansi2html.convert(StringIO.new(string)).html
    end
  end
end
