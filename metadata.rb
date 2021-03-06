name              'chef-prepare-weather'
maintainer        'Robert Kowalski'
maintainer_email  'rok@kowalski.gd'
license           'Apache 2.0'
description       'Installs/configures something'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           '1.0.5'
recipe            'chef-prepare-weather::default', 'Prepares everything the weather server needs (directories, cronjob)'

supports 'raspbian'

depends 'nodejs', '= 1.3.0' # https://github.com/mdxp/nodejs-cookbook/
depends 'ssh_known_hosts'