module RailsAdminJcrop
  module Orm
    module Extension

      CropFields = [:crop_x, :crop_y, :crop_w, :crop_h, :crop_field, :crop_process_before, :crop_process_after]

      def self.included(base)
        base.send :attr_accessor, *CropFields
      end



      def rails_admin_cropping?
        CropFields.all? {|f| send(f).present?}
      end

      def rails_admin_crop!(params)
        CropFields.each {|f| self.send "#{f}=", params[f] }
        ::RailsAdminJcrop::AssetEngine.crop!(self, self.crop_field) if self.rails_admin_cropping?
      end




      def auto_rails_admin_jcrop(field)
        if !rails_admin_cropping? and self.try("#{field}_default_crop_params") and self.try("#{field}_updated_at_changed?")
          rails_admin_crop! self.send("#{field}_default_crop_params")
        end
      end

      def default_crop_params_for_left_top(field, width, height, left_offset = 0, top_offset = 0)
        {
          crop_x: left_offset, crop_y: left_offset, crop_w: width, crop_h: height, crop_field: field,
          crop_process_before: '+repage', crop_process_after: '+repage'
        }
      end


      def default_crop_params_for_center(field, width, height, left_offset = 0, top_offset = 0)
        {
          crop_x: left_offset, crop_y: top_offset, crop_w: width, crop_h: height, crop_field: :image,
          crop_process_before: '-gravity Center', crop_process_after: '+repage'
        }
      end

    end
  end
end

if defined?(::ActiveRecord)
  ::ActiveRecord::Base.send(:include, ::RailsAdminJcrop::Orm::Extension)
end

if defined?(::Mongoid)
  module Mongoid
    module Document
      def self.included(base)
        base.send(:include, ::RailsAdminJcrop::Orm::Extension)
      end
    end
  end
end
