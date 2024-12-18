$:.push File.expand_path('../lib', __FILE__)
require 'omniauth/mantle/version'

Gem::Specification.new do |s|
  s.name        = "omniauth-mantle"
  s.version     = OmniAuth::Mantle::VERSION
  s.summary     = "Omniauth strategy for Mantle."
  s.description = "Omniauth strategy for Mantle."
  s.authors     = ["Liam Houlahan"]
  s.email       = "liamh@hey.com"
  s.files       = ["lib/omniauth_mantle.rb"]
  s.homepage    =
    "https://github.com/lanks/omniauth-mantle"
  s.license       = "MIT"

  s.add_runtime_dependency 'omniauth-oauth2', '~> 1.5'
  s.add_runtime_dependency 'activesupport'

  s.add_development_dependency 'minitest', '~> 5.6'
  s.add_development_dependency 'rspec', '~> 3.9.0'
  s.add_development_dependency 'fakeweb', '~> 1.3'
  s.add_development_dependency 'rack-session', '~> 2.0'
  s.add_development_dependency 'rake'
end