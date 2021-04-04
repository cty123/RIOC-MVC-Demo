class BaseController

  def self.descendants
    ObjectSpace.each_object(Class).select { |klass| klass < self }
  end

  def initialize(service)
  end
end
