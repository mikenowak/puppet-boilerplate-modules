# == Class: boilerplate::config
#
# This class exists to coordinate all configuration related actions,
# functionality and logical units in a central place.
#
#
# === Parameters
#
# This class does not provide any parameters.
#
#
# === Examples
#
# This class may be imported by other classes to use its functionality:
#   class { 'boilerplate::config': }
#
# It is not intended to be used directly by external resources like node
# definitions or other modules.
#
#
# === Authors
#
# * John Doe <mailto:john.doe@example.com>
#
class boilerplate::config {

  #### Configuration

  # set params: in operation
  if $boilerplate::ensure == 'present' {
    $config_ensure = 'present'
  # set params: removal
  } else {
    $config_ensure = 'absent'
  }

  # action
  file { $boilerplate::params::config_path:
    ensure  => $config_ensure,
    mode    => $boilerplate::params::config_mode,
    owner   => $boilerplate::params::config_owner,
    group   => $boilerplate::params::config_group,
    content => template($boilerplate::template),
    notify  => Service[$boilerplate::params::service],
  }
}
