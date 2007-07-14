class Object

  def Object.object_context(id)
    # define kernel-level context method
    Kernel.module_eval <<-end_eval
      def ronin_#{id}(*args,&block)
        new_obj = #{self}.new(*args)
        new_obj.instance_eval(&block)

        if ronin_object_pending?
          ronin_objects[:#{id}] = new_obj
          return nil
        else
          return new_obj
        end
      end
    end_eval

    Ronin::Repo.module_eval <<-end_eval
      def ronin_load_#{id}(path,&block)
        ronin_load_object(:#{id},path,&block)
      end
    end_eval
  end

end

