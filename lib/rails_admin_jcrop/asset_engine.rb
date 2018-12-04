if defined?(::CarrierWave)
  require 'rails_admin_jcrop/asset_engine/carrier_wave'
end
if defined?(::Paperclip)
  require 'rails_admin_jcrop/asset_engine/paperclip'
end
if defined?(::Shrine)
  require 'rails_admin_jcrop/asset_engine/shrine'
end
