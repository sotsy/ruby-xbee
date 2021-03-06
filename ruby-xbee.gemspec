# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ruby-xbee}
  s.version = "0.0.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Mike Ashmore"]
  s.autorequire = %q{ruby_xbee}
  s.date = %q{2009-04-30}
  s.email = %q{mike@motomike.net}
  s.executables = ["apicontrol.rb", "ruby-xbee.rb", "xbeeconfigure.rb", "xbeedio.rb", "xbeeinfo.rb", "xbeelisten.rb", "xbeesend.rb"]
  s.extra_rdoc_files = [
    "LICENSE",
    "README",
    "README.rdoc"
  ]
  s.files = [
    "LICENSE",
    "README.rdoc",
    "Rakefile",
    "VERSION.yml",
    "bin/apicontrol.rb",
    "bin/ruby-xbee.rb",
    "bin/xbeeconfigure.rb",
    "bin/xbeedio.rb",
    "bin/xbeeinfo.rb",
    "bin/xbeelisten.rb",
    "bin/xbeesend.rb",
    "lib/apimode/at_commands.rb",
    "lib/apimode/frame/at_command.rb",
    "lib/apimode/frame/at_command_response.rb",
    "lib/apimode/frame/explicit_addressing_command.rb",
    "lib/apimode/frame/explicit_rx_indicator.rb",
    "lib/apimode/frame/frame.rb",
    "lib/apimode/frame/modem_status.rb",
    "lib/apimode/frame/receive_packet.rb",
    "lib/apimode/frame/remote_command_request.rb",
    "lib/apimode/frame/remote_command_response.rb",
    "lib/apimode/frame/transmit_request.rb",
    "lib/apimode/frame/transmit_status.rb",
    "lib/apimode/xbee_api.rb",
    "lib/legacy/command_mode.rb",
    "lib/module_config.rb",
    "lib/ruby_xbee.rb",
    "test/ruby_xbee_test.rb",
    "test/test_helper.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/motomike/ruby-xbee}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Ripped ruby-xbee-1.0 from http://sawdust.see-do.org/ruby-xbee/releases/ruby-xbee-1.0/ruby-xbee-1.0.tar.gz on 20 April 2009; heavy modifications underway to support V2 XBee Pro 900MHz modules and generally  clean up code}
  s.test_files = [
    "test/ruby_xbee_test.rb",
    "test/test_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<ruby-serialport>, [">= 0"])
    else
      s.add_dependency(%q<ruby-serialport>, [">= 0"])
    end
  else
    s.add_dependency(%q<ruby-serialport>, [">= 0"])
  end
end
