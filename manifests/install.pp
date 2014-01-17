define plenv::install(
  $user  = $title,
  $group = $user,
  $home  = '',
  $root  = '',
  $rc    = '.profile'
) {

  $home_path = $home ? { '' => "/home/${user}", default => $home }
  $root_path = $root ? { '' => "${home_path}/.plenv", default => $root }

  $plenvrc = "${home_path}/.plenvrc"
  $shrc  = "${home_path}/${rc}"

  if ! defined( Class['plenv::dependencies'] ) {
    require plenv::dependencies
  }

  exec { "plenv::checkout ${user}":
    command => "git clone https://github.com/tokuhirom/plenv.git ${root_path}",
    user    => $user,
    group   => $group,
    creates => $root_path,
    path    => ['/bin', '/usr/bin', '/usr/sbin'],
    timeout => 100,
    cwd     => $home_path,
    require => Package['git'],
  }

  file { "plenv::plenvrc ${user}":
    path    => $plenvrc,
    owner   => $user,
    group   => $group,
    content => template('plenv/dot.plenvrc.erb'),
    require => Exec["plenv::checkout ${user}"],
  }

  exec { "plenv::shrc ${user}":
    command => "echo 'source ${plenvrc}' >> ${shrc}",
    user    => $user,
    group   => $group,
    unless  => "grep -q plenvrc ${shrc}",
    path    => ['/bin', '/usr/bin', '/usr/sbin'],
    require => File["plenv::plenvrc ${user}"],
  }

  file { "plenv::cache-dir ${user}":
    ensure  => directory,
    owner   => $user,
    group   => $group,
    path    => "${root_path}/cache",
    require => Exec["plenv::checkout ${user}"]
  }

  plenv::plugin::perlbuild { "plenv::perlbuild::${user}": 
	user    => $user,
	group   => $group,
	home    => $home,
	root    => $root,
	require => File["plenv::cache-dir ${user}"]
  }

}
