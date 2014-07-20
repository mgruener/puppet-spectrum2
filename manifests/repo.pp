class spectrum2::repo (
  $custom_repo = undef,
) {
  if ! $custom_repo {
    staging::file { '/etc/yum.repos.d/spectrum2-copr.repo':
      source => $::spectrum2::params::repoconfig_url,
      target => '/etc/yum.repos.d/spectrum2-copr.repo',
    }
  } else {
    create_resource('yumrepo', 'spectrum2-copr' => $custom_repo)
  }
}
