# == Class: boilerplate::params
#
# This class exists to
# 1. Declutter the default value assignment for class parameters.
# 2. Manage internally used module variables in a central place.
#
# Therefore, many operating system dependent differences (names, paths, ...)
# are addressed in here.
#
#
# === Parameters
#
# This class does not provide any parameters.
#
#
# === Examples
#
# This class is not intended to be used directly.
#
#
# === Links
#
# * {Puppet Docs: Using Parameterized Classes}[http://j.mp/nVpyWY]
#
#
# === Authors
#
# * John Doe <mailto:john.doe@example.com>
#
class boilerplate::params {

  #### Default values for the parameters of the main module class, init.pp

  # ensure
  $ensure = 'present'

  # version
  $version = 'present'

  # service status
  $status = 'enabled'

  # template file
  $template = 'FIXME/TODO'

  # options
  $options = ''


  #### Internal module values

  # packages
  case $::operatingsystem {
    'RedHat', 'CentOS', 'Fedora': {
      $package = [ 'FIXME/TODO' ]
    }
    'Debian', 'Ubuntu': {
      $package = [ 'FIXME/TODO' ]
    }
    default: {
      fail("\"${module_name}\" provides no package default value for \"${::operatingsystem}\"")
    }
  }

  # config parameters
  case $::operatingsystem {
    'RedHat', 'CentOS', 'Fedora': {
      $config_path        = 'FIXME/TODO'
      $config_mode        = '0600'
      $config_owner       = 'root'
      $config_group       = 'root'
    }
    'Debian', 'Ubuntu': {
      $config_path        = 'FIXME/TODO'
      $config_mode        = '0600'
      $config_owner       = 'root'
      $config_group       = 'root'
    }
    default: {
      fail("\"${module_name}\" provides no config parameters for \"${::operatingsystem}\"")
    }
  }

  # service parameters
  case $::operatingsystem {
    'RedHat', 'CentOS', 'Fedora': {
      $service            = 'FIXME/TODO'
      $service_hasrestart = true
      $service_hasstatus  = true
      $service_pattern    = $service
    }
    'Debian', 'Ubuntu': {
      $service            = 'FIXME/TODO'
      $service_hasrestart = true
      $service_hasstatus  = true
      $service_pattern    = $service
    }
    default: {
      fail("\"${module_name}\" provides no service parameters for \"${::operatingsystem}\"")
    }
  }
}
