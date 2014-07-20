define spectrum2::transport (
  $identity_type,
  $service_password,
  $service_jid = $title,
  $service_runas_user = 'spectrum',
  $service_runas_group = 'spectrum',
  $service_admin_jid = "gojaraadmin@${::domain}",
  $service_server = '127.0.0.1',
  $service_port = '5275',
  $service_backend_host = '127.0.0.1',
  $service_backend_port = undef,
  $service_users_per_backend = 10,
  $service_backend = '/usr/bin/spectrum2_libpurple_backend',
  $purple_protocol = undef,
  $communi_irc_server = undef,
  $communi_irc_identify = undef,
  $identity_name = "Spectrum ${identity_type} Transport",
  $identity_category = 'gateway',
  $logging_config = '/etc/spectrum2/logging.cfg',
  $logging_backend_config = '/etc/spectrum2/backend-logging.cfg',
  $database_type = $::spectrum2::dbtype,
  $database_database = undef,
  $database_server = $::spectrum2::dbserver,
  $database_port = $::spectrum2::dbport,
  $database_user = $::spectrum2::dbuser,
  $database_password = $::spectrum2::dbpassword,
  $database_prefix = 'jabber_',
  $database_connectionstring = undef,
  $registration_enable_public_registration = 1,
  $registration_username_label = undef,
  $registration_instructions = undef,
  $registration_require_local_account = 1,
  $registration_local_username_label = 'Local username (without @server.tld):',
  $registration_local_account_server = '127.0.0.1',
  $registration_local_account_server_timeout = 10000,
) {

  if $database_type != 'sqlite3' {
    if !$database_database {
      $database_database_real = "spectrum2_transport_${title}"
    } else {
      $database_database_real = $database_database
    }

    if !$database_server {
      $database_server_real = 'localhost'
    } else {
      $database_server_real = $database_server
    }

    if !$database_user {
      $database_user_real = 'spectrum2'
    } else {
      $database_user_real = $database_user
    }

    if !$database_port {
      case $database_type {
        'mysql': { $database_port_real = '3306' }
        'pgxx': { $database_port_real = '5432' }
        default: { fail("Database ${database_type} is not supported by spectrum2.") }
      }
    } else {
      $database_port_real = $database_port
    }

    if $database_type == 'pgxx' {
      if !$database_connectionstring {
        $database_connectionstring_real = "host=${database_server_real} user=${database_user_real} password=${database_password}"
      } else {
        $database_connectionstring_real = $database_connectionstring
      }
      if ! $database_connectionstring_real { fail("You have to provide a database connectionstring for transport ${title}") }
    }

    if ! $database_database_real { fail("You have to provide a database name for transport ${title}") }
    if ! $database_server_real { fail("You have to provide a database server for transport ${title}") }
    if ! $database_port_real { fail("You have to provide a database port for transport ${title}") }
    if ! $database_user_real { fail("You have to provide a database user for transport ${title}") }
    if ! $database_password { fail("You have to provide a database passwort for transport ${title}") }
  } else {
    $database_database_real = $database_database
  }

  # when using the libpurple backend, try to
  # autodetect the correct purple protocol id for the
  # gateway identity type
  case $service_backend {
    /.*purple.*/: {
      if ! $purple_protocol {
        case $identity_type {
          'gadu-gadu': { $purple_protocol_real = 'prpl-gg' }
          'myspaceim': { $purple_protocol_real = 'prpl-myspace' }
          'sametime': { $purple_protocol_real = 'prpl-meanwhile' }
          'xmpp': { $purple_protocol_real = 'prpl-jabber' }
          default: { $purple_protocol_real = "prpl-${identity_type}" }
        }
      } else {
        $purple_protocol_real = $purple_protocol
      }
    }
    /.*communi.*/: {
      if !$communi_irc_server {
        fail("You have to provide an irc server for transport ${title}")
      }
    }
    /.*skype.*/: {
      $service_users_per_backend_real = 1
    }
  }

  if $service_backend !~ /.*skype.*/ {
    $service_users_per_backend_real = $service_users_per_backend
  }

  if $database_type == 'mysql' {
    @@mysql::db { $database_database_real:
      user     => $database_user_real,
      password => $database_password,
      host     => $::fqdn,
      tag      => 'spectrum2_transport_db',
    }
  }

  file { "/etc/spectrum2/transports/${title}.cfg":
    ensure  => file,
    content => template('spectrum2/spectrum_transport.cfg.erb'),
    owner   => 'root',
    group   => $runas_group,
    mode    => '0666'
  }
}
