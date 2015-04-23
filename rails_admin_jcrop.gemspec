$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rails_admin_jcrop/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ack_rails_admin_jcrop"
  s.version     = RailsAdminJcrop::VERSION
  s.authors     = ["ack43", "Jan Xie", ]
  s.email       = ["i43ack@gmail.com", "jan.h.xie@gmail.com", ]
  s.homepage    = "https://github.com/ack43/rails_admin_jcrop"
  s.summary     = "Jcrop plugin for rails admin. Forked from https://github.com/janx/rails_admin_jcrop"
  s.description = "#{s.summary} Image cropping made easy!"

  s.files = Dir["{app,config,db,lib,vendor}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.markdown"]

  s.add_dependency "rails", ">= 3.0.0"
  s.add_dependency "rails_admin", ">= 0.3.0"
  s.add_dependency "mini_magick"
end
