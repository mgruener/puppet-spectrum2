class spectrum2::dbhost (
  $mysqlpassword,
  $serverhostname = 'localhost',
  $mysqluser      = 'spectrum2',
  $mysqldb        = 'spectrum2',
) {

  if downcase($serverhostname) in downcase([ $::fqdn, $::hostname ]) {
    $spectrum2server = 'localhost'
  }
  else {
    $spectrum2server = $serverhostname
  }

  mysql::db { $mysqldb:
    user     => $mysqluser,
    password => $mysqlpassword,
    host     => $spectrum2server
  }
}
