module RailsAdminJcrop
  module AssetEngine
    class << self
      def thumbnail_names(obj, field)
        obj.send(field).styles.keys
      end

      def crop!(obj, field)
        _field = obj.send(field)
        _field.reprocess!

        # _field.reprocess!(*(_field.styles.keys - [:original]))
        # _field.reprocess_without_saving_instance(*(_field.styles.keys - [:original]))
      end

      def crop(obj, field)
        _field = obj.send(field)
        _field.reprocess_without_saving_instance
        
        # _field.reprocess!(*(_field.styles.keys - [:original]))
        # _field.reprocess_without_saving_instance(*(_field.styles.keys - [:original]))
      end
    end
  end
end

module Paperclip

  class Attachment
    # remaded from reprocess!
    def reprocess_without_saving_instance(*style_args)
      saved_only_process, @options[:only_process] = @options[:only_process], style_args
      saved_preserve_files, @options[:preserve_files] = @options[:preserve_files], true
      begin
        assign(self)
        save
        # instance.save
      rescue Errno::EACCES => e
        warn "#{e} - skipping file."
        false
      ensure
        @options[:only_process] = saved_only_process
        @options[:preserve_files] = saved_preserve_files
      end
    end
  end

  module RailsAdminJcropperMethods
    def has_attached_file(*args)
      super
      self.attachment_definitions.each do |name, options|
        options[:processors] ||= []
        options[:processors] << :rails_admin_jcropper
        options[:processors].uniq!
      end
    end
  end

  module ClassMethods
    def self.extended(base)
      super
      base.send :extend, ::Paperclip::RailsAdminJcropperMethods
    end
  end

  class RailsAdminJcropper < Thumbnail
    def transformation_command
      if @attachment.instance.rails_admin_cropping? and @options[:style] != :original
        ary = super
        if i = ary.index('-crop')
          ary.delete_at i+1
          ary.delete_at i
        end

        process_before  = [@attachment.instance.crop_process_before]
        crop            = ['-crop', crop_params]
        process_after   = [@attachment.instance.crop_process_after]

        process_before + crop + process_after + ary
      else
        super
      end
    end

    def crop_params
      target = @attachment.instance

      w = target.crop_w.to_i
      h = target.crop_h.to_i
      x = target.crop_x.to_i
      y = target.crop_y.to_i

      x = "+#{x}" if x >= 0
      y = "+#{y}" if y >= 0
      geometry = "#{w}x#{h}#{x}#{y}"

      geometry
    end
  end

end

module RailsAdmin
  module Config
    module Fields
      module Types
        module UploaderMethods

          def self.included(base)
            base.register_instance_option(:cache_method) do
              nil
            end

            base.register_instance_option(:thumb_method) do
              @thumb_method ||= ((styles = bindings[:object].send(name).styles.keys).find{|k| k.in?([:thumb, :thumbnail, 'thumb', 'thumbnail'])} || styles.first.to_s)
            end

            base.register_instance_option(:delete_method) do
              "delete_#{name}" if bindings[:object].respond_to?("delete_#{name}")
            end
          end

          def resource_url(thumb = false)
            return nil unless (attachment = bindings[:object].send(name)).present?
            thumb.present? ? attachment.url(thumb) : attachment.url
          end

        end
      end
    end
  end
end
