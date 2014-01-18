define plenv::carton(
  $home,
  $user,
  $perl    = $title,
  $group   = $user,
  $content = '',
  $modules = ''
) {

  if ( $modules ) {
    $cpanfile = template('plenv/cpanfile.erb')
  } elsif ( $content ) {
    $cpanfile = $content
  } else {
    fail('carton requires either a cpanfile')
  }

  file {"${user}/cpanfile":
    ensure  => present,
    path    => "${home}/cpanfile",
    owner   => $user,
    group   => $group,
    content => $cpanfile,
    backup  => false,
  }

  exec {"plenv::carton::${user} ${perl}":
    command   => "env PLENV_VERSION=${perl} carton install",
    cwd       => $home,
    user      => $user,
    group     => $group,
    path      => "${home}/bin:${home}/.plenv/shims:/bin:/usr/bin",
    creates   => "${home}/cpanfile.lock",
    subscribe => File["${user}/cpanfile"],
  }

}
