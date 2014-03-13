define plenv::client(
  $user,
  $home,
  $perl,
  $owner,
  $source,
  $rc = '.profile'
) {

  if !defined(Class['plenv']) {
    fail('You must include the plenv base class before using any plenv defined resource types')
  }

  if ! defined(Exec["plenv::compile ${owner} ${perl}"]) {
    fail("Perl version ${perl} is not compiled for ${owner}")
  }

  file {"${user}/.plenv":
    ensure => link,
    path   => "${home}/.plenv",
    target => "${source}/.plenv",
  }

  file {"${user}/${rc}":
    ensure => link,
    path   => "${home}/${rc}",
    target => "${source}/${rc}",
  }

  file {"${user}/.plenv-version":
    ensure  => present,
    path    => "${home}/.plenv-version",
    content => "${perl}\n",
  }

  file {"${user}/bin":
    ensure => directory,
    path   => "${home}/bin",
    owner  => $user,
  }

  file {"${user}/bin/plenv":
    ensure => link,
    path   => "${home}/bin/plenv",
    target => "${source}/.plenv/bin/plenv",
  }
}
