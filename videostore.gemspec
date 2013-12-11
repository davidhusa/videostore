Gem::Specification.new do |s|
  s.name        = 'videostore'
  s.version     = '0.0.3'
  s.date        = '2013-12-01'
  s.summary     = 'Utility for storing/tracking remote videos'
  s.description = "The videostore gem is a utility for storing " << 
                  "and tracking remote videos at streaming sites " << 
                  "such as Vimeo and Youtube."
  s.authors     = ['David Husa']
  s.email       = 'davidhusa@gmail.com'
  s.files       = ['lib/videostore.rb', 'spec/videostore_spec.rb',
                   'rakefile', 'README.md']
  s.homepage    = 'http://davidhusa.com'
  s.add_runtime_dependency 'faraday'
  s.add_runtime_dependency 'google-api-client'
  s.add_runtime_dependency 'vimeo'
  s.license     = 'MIT'
end
