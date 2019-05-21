module RailsAdminJcrop
  module AssetEngine
    class << self
      def s_thumbnail_names(obj, field)
        obj.send(field).keys rescue []
      end

      def s_crop!(obj, field)
        _field = obj.send(:"reprocess_#{field}!")
      end

      def s_crop(obj, field)
        _field = obj.send(:"reprocess_#{field}")
      end
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
              versions = bindings[:object].send(name).try(:keys)
              @thumb_method ||= (versions.find{|k| k.in?([:thumb, :thumbnail, 'thumb', 'thumbnail'])} || versions.first.to_s)
            end

            base.register_instance_option(:delete_method) do
              "delete_#{name}" if bindings[:object].respond_to?("delete_#{name}")
            end
          end

          def resource_url(thumb = false)
            return nil unless (attachment = bindings[:object].send(name)).present?
            if attachment.is_a?(Hash)
              (attachment[thumb] || attachment[:original]).url
            else
              attachment.url
            end
          end

        end
      end
    end
  end
end
