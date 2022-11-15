require 'rake'

Gem::Specification.new do |s|
    s.name = "kirb"
    s.version = "0.0.1"
    s.summary = "kirb web framework"
    s.description = "A minimalist web framework for ruby"
    s.author = "Alberto Elorza"
    s.files = FileList['lib/**/*.rb']
    s.license = "MIT"
    s.executables << 'kirb'
end