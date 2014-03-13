define plenv::install(
  $user  = $title,
  $group = $user,
  $root  = $::plenv::default_root_path,
  $home  = $::plenv::default_home_path,
  $rc    = $::plenv::bash_profile
) {

  if !defined(Class['plenv']) {
    fail('You must include the plenv base class before using any plenv defined resource types')
  }

  $home_path = $home ? { '' => "/home/${user}", default => $home }
  $root_path = $root ? { '' => "${home_path}/.plenv", default => $root }

  $plenvrc = "${home_path}/.plenvrc"
  $shrc  = "${home_path}/${rc}"

  exec { "plenv::checkout ${user}":
    command => "git clone $::plenv::plenv_git_url ${root_path}",
    user    => $user,
    group   => $group,
    creates => $root_path,
    path    => $::plenv::default_paths,
    timeout => $::plenv::default_exec_timeout,
    cwd     => $home_path,
    require => Package['git'],
  }

  file { "plenv::plenvrc ${user}":
    path    => $plenvrc,
    owner   => $user,
    group   => $group,
    content => template($::plenv::plenvrc_template),
    require => Exec["plenv::checkout ${user}"],
  }

  exec { "plenv::shrc ${user}":
    command => "echo 'source ${plenvrc}' >> ${shrc}",
    user    => $user,
    group   => $group,
    unless  => "grep -q plenvrc ${shrc}",
    path    => $::plenv::default_paths,
    require => File["plenv::plenvrc ${user}"],
  }

  file { "plenv::cache-dir ${user}":
    ensure  => directory,
    owner   => $user,
    group   => $group,
    path    => "${root_path}/cache",
    require => Exec["plenv::checkout ${user}"]
  }

    plenv::plugin::perlbuild { "plenv::perlbuild ${user}":
    user    => $user,
    group   => $group,
    home    => $home,
    root    => $root,
    require => File["plenv::cache-dir ${user}"]
    }

}
