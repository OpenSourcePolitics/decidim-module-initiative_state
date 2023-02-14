# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/initiative_state/version"

Gem::Specification.new do |s|
  s.version = Decidim::InitiativeState.version
  s.authors = ["Elie Gaboriau"]
  s.email = ["elie@opensourcepolitics.eu"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/decidim/decidim-module-initiative_state"
  s.required_ruby_version = ">= 3.0"

  s.name = "decidim-initiative_state"
  s.summary = "A decidim initiative_state module"
  s.description = "This module enables initiatives to have a state."

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE-AGPLv3.txt", "Rakefile", "README.md"]

  s.add_dependency "decidim-core", Decidim::InitiativeState.decidim_compatibility_version
  s.metadata["rubygems_mfa_required"] = "true"
end
