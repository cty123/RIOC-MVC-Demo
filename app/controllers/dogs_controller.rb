class DogsController < BaseController

  inject :foo
  def initialize(foo)
    @foo = foo
  end

  def bark
    puts @foo
  end
end