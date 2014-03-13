define plenv::carton(
  $home,
  $user,
  $perl    = $title,
  $group   = $user,
  $content = $::plenv::default_cpanfile_content,
  $modules = $::plenv::default_cpan_modules
) {

  if !defined(Class['plenv']) {
    fail('You must include the plenv base class before using any plenv defined resource types')
  }

  if ( $modules ) {
    $cpanfile = template($::plenv::cpanfile_template)
  } elsif ( $content ) {
    $cpanfile = $content
  } else {
    fail('carton requires either a list of modules or cpanfile content')
  }

  file { "${home}/${::plenv::cpanfile_name}":
    ensure  => present,
    path    => "${home}/${::plenv::cpanfile_name}",
    owner   => $user,
    group   => $group,
    content => $cpanfile,
    backup  => false,
  }

  exec {"plenv::carton ${user} ${perl}":
    command   => "env HOME=${home} PLENV_VERSION=${perl} carton install",
    cwd       => $home,
    user      => $user,
    group     => $group,
    path      => "${home}/bin:${home}/.plenv/shims:/bin:/usr/bin",
    creates   => "${home}/${::plenv::carton_lock_file}",
    subscribe => File["${home}/${::plenv::cpanfile_name}"],
    require   => Plenvcpanm["${user}/${perl}/Carton"]
  }

}
