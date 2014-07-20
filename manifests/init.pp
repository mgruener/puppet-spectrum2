# All backends:
#  $backends = [ "${package}-libcommuni-backend",
#                "${package}-libpurple-backend",
#                "${package}-skype-backend",
#                "${package}-smstools3-backend",
#                "${package}-swiften-backend",
#                "${package}-twitter-backend",
#                "${package}-yahoo-backend",
#  ]
#
class spectrum2 (
  $ensure = running,
  $enable = true,
  $package = $::spectrum2::params::package,
  $service = $::spectrum2::params::service,
  $service_provider = $::spectrum2::params::service_provider,
  $backends = [ "${package}-libcommuni-backend",
                "${package}-libpurple-backend",
  ],
  $use_external_repo = true,
  $dbtype = 'sqlite3',
  $dbserver = undef,
  $dbport = undef,
  $dbpassword = undef,
  $dbuser = undef,
  $transports = undef,
) inherits spectrum2::params {

  package { $package: } -> package { $backends: }

  if $use_external_repo == true {
    include spectrum2::repo
  }

  service { $service:
    ensure   => $ensure,
    enable   => $enable,
    provider => $service_provider,
  }

  if $transports {
    create_resources('spectrum2::transport',$transports)
  }
}
