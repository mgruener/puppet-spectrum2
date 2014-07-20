class spectrum2::params {
  if $::kernel != 'Linux' {
    fail("${module_name} is only supported on Linux")
  }

  # no debian support at the moment...
  $package = 'spectrum2'
  $service = 'spectrum2'
  $service_provider = 'redhat'
  case $::operatingsystem {
    /^Fedora/: {
      case $::operatingsystemmajrelease {
        19: { $repoconfig_url = 'https://copr.fedoraproject.org/coprs/mcepl/spectrum2/repo/fedora-19/mcepl-spectrum2-fedora-19.repo' }
        20: { $repoconfig_url = 'https://copr.fedoraproject.org/coprs/mcepl/spectrum2/repo/fedora-20/mcepl-spectrum2-fedora-20.repo' }
        'rawhide': { $repoconfig_url = 'https://copr.fedoraproject.org/coprs/mcepl/spectrum2/repo/fedora-rawhide/mcepl-spectrum2-fedora-rawhide.repo' }
        default:  { fail("${module_name}::repo is not supported on ${::operatingsystem} ${$::operatingsystemmajrelease}") }
      }
    }
    /^RedHat|^CentOS/: {
      case $::operatingsystemmajrelease {
        6: { $repoconfig_url = 'https://copr.fedoraproject.org/coprs/mcepl/spectrum2/repo/epel-6/mcepl-spectrum2-epel-6.repo' }
        7: { $repoconfig_url = 'https://copr.fedoraproject.org/coprs/mcepl/spectrum2/repo/epel-7/mcepl-spectrum2-epel-7.repo' }
        default:  { fail("${module_name}::repo is not supported on ${::operatingsystem} ${$::operatingsystemmajrelease}") }
      }
    }
    default: { fail("${module_name} is not supported on ${::operatingsystem}") }
  }
}
