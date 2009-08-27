require 'ronin/templates/template'

class ExampleTemplate

  include Ronin::Templates::Template

  def enter_example_template(&block)
    enter_template(File.join('templates','example.erb'),&block)
  end

  def enter_relative_template(&block)
    enter_template(File.join('templates','example.erb')) do |path|
      enter_template('_relative.erb',&block)
    end
  end

  def enter_missing_template(&block)
    enter_template('totally_missing.erb',&block)
  end

end
