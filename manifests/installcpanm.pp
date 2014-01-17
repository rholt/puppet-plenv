# The following part installs cpanm into the chosen perl version
#
define plenv::installcpanm(
  $user,
  $perl           = $title,
  $group          = $user,
  $home           = '',
  $root           = '',
  $source         = '',
  $carton         = present
) {

  $home_path = $home ? { '' => "/home/${user}", default => $home }
  $root_path = $root ? { '' => "${home_path}/.plenv", default => $root }

  $bin         = "${root_path}/bin"
  $shims       = "${root_path}/shims"
  $versions    = "${root_path}/versions"
  $global_path = "${root_path}/version"
  $path        = [ $shims, $bin, '/bin', '/usr/bin' ]

  if ! defined( Class['plenv::dependencies'] ) {
    require plenv::dependencies
  }

  # Set Timeout to disabled cause we need a lot of time to compile.
  # Use HOME variable and define PATH correctly.
  exec { "plenv::installcpanm ${user} ${perl}":
    command     => "env PLENV_VERSION=${perl} plenv install-cpanm",
    timeout     => 0,
    user        => $user,
    group       => $group,
    cwd         => $home_path,
    environment => [ "HOME=${home_path}" ],
    path        => $path,
    logoutput   => 'on_failure',
    #require     => Plenv::Plugin["plenv::plugin::perlbuild::${user}"],
    require     => Exec["plenv::compile ${user} ${perl}"],
  }

  # Install carton
  #
  plenv::cpanm {"plenv::carton ${user} ${perl}":
    ensure => $carton,
    user   => $user,
    perl   => $perl,
    module => 'Carton',
    home   => $home_path,
    root   => $root_path,
	require => Exec["plenv::installcpanm ${user} ${perl}"]
  }
}
