require 'ronin/templates/template'

class ExampleTemplate

  include Ronin::Templates::Template

  def enter_example_template(&block)
    enter_template('example_template.txt',&block)
  end

  def enter_relative_template(&block)
    enter_template('example_template.txt') do |path|
      enter_template('_relative_template.txt',&block)
    end
  end

  def enter_missing_template(&block)
    enter_template('totally_missing.txt',&block)
  end

end
