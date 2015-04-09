# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_mail_chimp'
  s.version     = '2.3.0'
  s.summary     = 'Mail Chimp subscriptions for your Spree store using mailchimp-api'
  s.required_ruby_version = '>= 1.9.3'

  s.author            = 'Sam Beam'
  s.email             = 'sbeam@onsetcorps.net'
  s.homepage          = 'https://github.com/sbeam/spree-mail-chimp'


  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")

  s.require_path = 'lib'
  s.requirements << 'none'

  s.has_rdoc = true

  s.add_dependency 'spree_core', '~> 2.3.0'
  s.add_dependency 'mailchimp-api', '~> 2.0.4'
end
