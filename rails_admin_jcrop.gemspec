$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rails_admin_jcrop/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ack_rails_admin_jcrop"
  s.version     = RailsAdminJcrop::VERSION
  s.authors     = ["Alexander Kiseliev", "Jan Xie"]
  s.email       = ["dev@redrocks.pro", "jan.h.xie@gmail.com", ]
  s.homepage    = "https://github.com/red-rocks/rails_admin_jcrop"
  s.summary     = "Jcrop plugin for rails admin. Forked from https://github.com/janx/rails_admin_jcrop"
  s.description = "#{s.summary} Image cropping made easy!"

  s.files = Dir["{app,config,db,lib,vendor}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.markdown"]

  s.add_dependency "rails_admin", ">= 2.0"
  s.add_dependency "mini_magick"
end
