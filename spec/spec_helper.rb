$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'annotate_gemfile'
require 'awesome_print'
require 'pry-byebug'

class String
  def strip_heredoc
    indent = scan(/^[ \t]*(?=\S)/).min
    indent = (indent && indent.size) || 0
    gsub(/^[ \t]{#{indent}}/, '')
  end
end
