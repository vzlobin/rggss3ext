class Class

  def after(method, &block)
    original = create_unique_alias(method)
    define_method method do |*args|
      self.__send__(original, *args)
      instance_exec(*args, &block)
    end
  end

  def before(method, &block)
    original = create_unique_alias(method)
    define_method method do |*args|
      instance_exec(*args, &block)
      self.__send__(original, *args)
    end
  end

  def instead_of(method, &block)
    original = create_unique_alias(method)
    define_method method do |*args|
      original_block = proc { |*args| 
        self.__send__(original, *args)
      }
      actual_args = [ original_block ] + args
      instance_exec(*actual_args, &block)
    end
  end

  def after_init(&block)
    after :initialize, &block
  end

  private
  @@alias_index = 0
  def create_unique_alias(method)
    @@alias_index += 1
    original = "_alias#{@@alias_index}_#{method}".to_sym
    class_eval %Q{
      alias_method :#{original}, :#{method}
    }
    original
  end

end
