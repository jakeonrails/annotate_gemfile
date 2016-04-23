require 'spec_helper'

describe AnnotateGemfile::Annotator do
  subject(:annotator) { AnnotateGemfile::Annotator.new }

  describe '#annotate' do
  end

  describe '#annotate_lines' do
    context 'gem declarations' do
      let(:input) {
        <<-RUBY.strip_heredoc.split("\n")
        gem 'whatdo'
        gem "WHATDO"
        gem 'no-info'
          gem 'long-info'
        # Test trailing blank lines
        RUBY
      }
      let(:output) { annotator.annotate_lines(input) }

      before do
        expect(Gems).to receive(:info).with('whatdo') {
          {
            'info' => 'whatdo helps you figure out what to do next',
          }
        }

        expect(Gems).to receive(:info).with('WHATDO') {
          {
            'info' => 'WHATDO helps you figure out what you *need* to do next',
            'source_code_uri' => 'https://github.com/whatdo/WHATDO',
          }
        }

        expect(Gems).to receive(:info).with('no-info') {
          "Could not find gem'"
        }

        expect(Gems).to receive(:info).with('long-info') {
          {
            'info' => 'This is a long description to illustrate the line-wrapping of the results. It should wrap onto two lines, properly indented.',
          }
        }
      end

      it 'prepends a gem desription before the gem declaration and appends a blank line' do
        expect(output).to eq(
        <<-RUBY.strip_heredoc.split("\n")
        # whatdo helps you figure out what to do next
        gem 'whatdo'

        # WHATDO helps you figure out what you *need* to do next
        # (https://github.com/whatdo/WHATDO)
        gem "WHATDO"

        gem 'no-info'

          # This is a long description to illustrate the line-wrapping of the results.
          # It should wrap onto two lines, properly indented.
          gem 'long-info'

        # Test trailing blank lines
        RUBY
        )
      end
    end

    context 'when given a gemspec declaration' do
      let(:input) {
        <<-RUBY.strip_heredoc.split("\n")
        gemspec
        RUBY
      }
      let(:output) { annotator.annotate_lines(input) }
      it 'does not modify any lines' do
        expect(output).to eq input
      end
    end

    context 'when given arbitrary Ruby' do
      let(:input) {
        <<-RUBY.strip_heredoc.split("\n")
        source 'https://rubygems.org'

        def some_method(y)
          x = 4
        end
        RUBY
      }
      let(:output) { annotator.annotate_lines(input) }

      it 'does not modify any lines' do
        expect(output).to eq input
      end
    end

    context 'when given comments' do
      let(:input) {
        <<-RUBY.strip_heredoc.split("\n")
        # Unindented
          # One comment
          # Two comments
        =begin
        gem 'not a comment'
        =end
        RUBY
      }

      let(:output) { annotator.annotate_lines(input) }

      it 'does not modify any lines' do
        expect(output).to eq input
      end
    end

    describe '#word_wrap' do
      it 'wraps text with newlines at whitespace boundaries' do
        input = 'This is a long description to illustrate the line-wrapping of the results. It should wrap onto two lines, properly indented.'
        expect(annotator.word_wrap(input, 76)).to eq "This is a long description to illustrate the line-wrapping of the results.\nIt should wrap onto two lines, properly indented."
      end
    end
  end

  it 'works against a whole file' do
    expect(annotator.annotate_lines(GEMFILE.split("\n"))).to eq ANNOTATED.split("\n")
  end
end

GEMFILE = <<-RUBY
source "https://rubygems.org"

ruby '2.3.0'

gem 'rails', '~> 5.0.0'

group :development, :test do
  gem 'rspec-rails', '~3.1.4'
end
RUBY

ANNOTATED = <<-RUBY
source "https://rubygems.org"

ruby '2.3.0'

# Ruby on Rails is a full-stack web framework optimized for programmer happiness
# and sustainable productivity. It encourages beautiful code by favoring
# convention over configuration. (http://github.com/rails/rails)
gem 'rails', '~> 5.0.0'


group :development, :test do
  # rspec-rails is a testing framework for Rails 3.x and 4.x.
  # (http://github.com/rspec/rspec-rails)
  gem 'rspec-rails', '~3.1.4'

end
RUBY
