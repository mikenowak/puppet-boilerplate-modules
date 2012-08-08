# == Class: boilerplate
#
# This class is able to install or remove boilerplate on a node.
#
# === Parameters
#
# [*ensure*]
#   String. Controls if the managed resources shall be <tt>present</tt> or
#   <tt>absent</tt>. If set to <tt>absent</tt>:
#   * The managed software packages are being uninstalled.
#   * Any traces of the packages will be purged as good as possible. This may
#     include existing configuration files. The exact behavior is provider
#     dependent. Q.v.:
#     * Puppet type reference: {package, "purgeable"}[http://j.mp/xbxmNP]
#     * {Puppet's package provider source code}[http://j.mp/wtVCaL]
#   * System modifications (if any) will be reverted as good as possible
#     (e.g. removal of created users, services, changed log settings, ...).
#   * This is thus destructive and should be used with care.
#   Defaults to <tt>present</tt>.
#
# [*version*]
#   The package version, used in the ensure parameter of package type.
#   Can be 'latest' or a specific version number.
#   Defaults to <tt>present</tt>.
#
# [*status*]
#   String to define the status of the service. Possible values:
#   * <tt>enabled</tt>: Service is running and will be started at boot time.
#   * <tt>disabled</tt>: Service is stopped and will not be started at boot
#     time.
#   * <tt>running</tt>: Service is running but will not be started at boot time.
#     You can use this to start a service on the first Puppet run instead of
#     the system startup.
#   * <tt>unmanaged</tt>: Service will not be started at boot time and Puppet
#     does not care whether the service is running or not. For example, this may
#     be useful if a cluster management software is used to decide when to start
#     the service plus assuring it is running on the desired node.
#   Defaults to <tt>enabled</tt>. The singular form ("service") is used for the
#   sake of convenience. Of course, the defined status affects all services if
#   more than one is managed (see <tt>service.pp</tt> to check if this is the
#   case).
#
# [*template*]
#   String to define the path for the template to use as content for main
#   configuration file.
#   Defaults to <tt>boilerplate/[FIXME/TODO].erb</tt>.
#
# [*options*]
#   An hash of custom options to be used in templates for arbitrary settings.
#
# The default values for the parameters are set in boilerplate::params. Have
# a look at the corresponding <tt>params.pp</tt> manifest file if you need more
# technical information about them.
#
#
# === Examples
#
# * Installation:
#     class { 'boilerplate': }
#
# * Removal/decommissioning:
#     class { 'boilerplate':
#       ensure => 'absent',
#     }
#
# * Install everything and use a custom template for the config file:
#     class { 'boilerplate':
#       template => 'site/config.erb',
#     }
#
# * Install everything and set options in the config file:
# [FIXME/TODO] PROVIDE SOME EXAMPLES
#     class { 'boilerplate':
#       options => {
#         'debug' => '1',
#       }
#     }
#
#
# === Authors
#
# * John Doe <mailto:john.doe@example.com>
#
class boilerplate(
  $ensure                 = params_lookup('ensure'),
  $version                = params_lookup('version'),
  $status                 = params_lookup('status'),
  $template               = params_lookup('template'),
  $options                = params_lookup('options')
) inherits boilerplate::params {

  #### Validate parameters

  # ensure
  if ! ($ensure in [ 'present', 'absent' ]) {
    fail("\"${ensure}\" is not a valid ensure parameter value")
  }

  # service status
  if ! ($status in [ 'enabled', 'disabled', 'running', 'unmanaged' ]) {
    fail("\"${status}\" is not a valid status parameter value")
  }


  #### Manage actions

  # package(s)
  class { 'boilerplate::package': }

  # configuration
  class { 'boilerplate::config': }

  # service(s)
  class { 'boilerplate::service': }


  #### Manage relationships

  if $ensure == 'present' {
    # we need the software before configuring it
    Class['boilerplate::package'] -> Class['boilerplate::config']

    # we need the software and a working configuration before running a service
    Class['boilerplate::package'] -> Class['boilerplate::service']
    Class['boilerplate::config']  -> Class['boilerplate::service']
  } else {
    # make sure all services are getting stopped before software removal
    Class['boilerplate::service'] -> Class['boilerplate::package']
  }
}
