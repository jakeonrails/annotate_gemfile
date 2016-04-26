require 'gems'
require 'ruby-progressbar'

module AnnotateGemfile
  class Annotator

    COMMENT = /^#.*/
    BEGIN_COMMENT = /^=begin/
    END_COMMENT = /^=end/
    GEM_DECLARATION = /^gem\s+/
    GEM_NAME = /gem\s+[('"]([^'")]+)/
    BLANK_LINE = /^\s*$/

    def initialize
      @block_comment = false
      @progress = ProgressBar.create
    end

    def annotate(filename)
      lines = File.readlines(filename)
      gem_count = lines.count { |line| line.strip =~ GEM_DECLARATION }

      @progress = ProgressBar.create(total: gem_count,
                                     format:  '%a %bᗧ%i %p%% %t %c/%C',
                                     progress_mark:  ' ',
                                     remainder_mark: '･')

      annotated = annotate_lines(lines)
      File.write("#{filename}.annotated", annotated.join("\n"))
    end

    def annotate_lines(lines)
      output = lines.each_with_object([]) do |line, output|
        annotated = Array(send(type_of(line), line))
        output.concat annotated
      end.flatten
      output
    end

    def gem(line)
      [
        describe_gem(line),
        line,
        '',
      ].compact.flatten.tap { @progress.increment }
    end

    def blank(line)
      line.gsub("\n", '')
    end

    def comment(line)
      line.gsub("\n", '')
    end

    def unknown(line)
      line.gsub("\n", '')
    end

    def describe_gem(line)
      indent = line[/\s*/].to_s
      comment = indent + '# '
      line_width = 80 - comment.length

      gem_name = line[GEM_NAME, 1]
      return unless description = gem_info_for(gem_name)
      description = word_wrap(description, line_width).split("\n")
      description.map {|d| comment + d.to_s }
    end

    def gem_info_for(gem_name)
      return unless info = Gems.info(gem_name)
      comment = info['info']
      comment += " (#{info['source_code_uri']})" if info['source_code_uri']
      comment
    end

    def word_wrap(text, line_width)
      squish(text).split("\n").map do |line|
        line.length > line_width ? line.gsub(/(.{1,#{line_width}})(\s+|$)/, "\\1\n").strip : line
      end.join
    end

    def type_of(line)
      stripped = line.strip
      return :comment if @block_comment && stripped !=~ /^=end/

      case stripped
      when COMMENT
        :comment
      when BEGIN_COMMENT || END_COMMENT
        @block_comment = !@block_comment
        :comment
      when GEM_DECLARATION
        :gem
      when BLANK_LINE
        :blank
      else
        :unknown
      end
    end

    def squish(text)
      text.gsub(/\A[[:space:]]+/, '')
          .gsub(/[[:space:]]+\z/, '')
          .gsub(/[[:space:]]+/, ' ')
    end

  end
end
