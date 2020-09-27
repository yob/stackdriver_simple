Gem::Specification.new do |spec|
  spec.name = "stackdriver_simple"
  spec.version = "0.0.1"
  spec.summary = "An easy way to submit metrics to stackdriver"
  spec.description = "An easy way to submit metrics to stackdriver"
  spec.license = "MIT"
  spec.files =  Dir.glob("{lib}/**/**/*")
  spec.extra_rdoc_files = %w{README.md MIT-LICENSE }
  spec.authors = ["James Healy"]
  spec.email   = ["james@yob.id.au"]
  spec.homepage = "http://github.com/yob/stackdriver_simpler"
  spec.required_ruby_version = ">=1.9.3"

  spec.add_development_dependency("rspec", "~> 3.5")

  spec.add_dependency("google-cloud-monitoring", "< 1.0")
end
