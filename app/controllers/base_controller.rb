class BaseController

  def self.descendants
    ObjectSpace.each_object(Class).select { |klass| klass < self }
  end

  def self.inject(*params)
    @@params = params
    self.class_eval do
      def self.injector(c)
        deps = @@params.map { |p| c.resolve(p) }
        self.new(*deps)
      end
    end
  end

end
