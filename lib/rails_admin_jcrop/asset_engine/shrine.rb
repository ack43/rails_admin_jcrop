module RailsAdminJcrop
  module AssetEngine
    class << self
      def thumbnail_names(obj, field)
        obj.send(field).styles.keys
      end

      def crop!(obj, field)
        _field = obj.send(:"reprocess_#{field}!")
      end

      def crop(obj, field)
        _field = obj.send(:"reprocess_#{field}")
      end
    end
  end
end

# module RailsAdmin
#   module Config
#     module Fields
#       module Types
#         module UploaderMethods

#           def self.included(base)
#             base.register_instance_option(:cache_method) do
#               nil
#             end

#             base.register_instance_option(:thumb_method) do
#               @thumb_method ||= ((styles = bindings[:object].send(name).styles.keys).find{|k| k.in?([:thumb, :thumbnail, 'thumb', 'thumbnail'])} || styles.first.to_s)
#             end

#             base.register_instance_option(:delete_method) do
#               "delete_#{name}" if bindings[:object].respond_to?("delete_#{name}")
#             end
#           end

#           def resource_url(thumb = false)
#             return nil unless (attachment = bindings[:object].send(name)).present?
#             thumb.present? ? attachment.url(thumb) : attachment.url
#           end

#         end
#       end
#     end
#   end
# end
