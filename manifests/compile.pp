# The following part compiles and installs the chosen perl version,
# using the "perl-build" plenv plugin.
#
define plenv::compile(
  $user,
  $perl           = $title,
  $group          = $user,
  $home           = $::plenv::default_home_path,
  $root           = $::plenv::default_root_path,
  $source         = '',
  $global         = false,
) {

  if !defined(Class['plenv']) {
        fail('You must include the plenv base class before using any plenv defined resource types')
  }

  $home_path = $home ? { '' => "/home/${user}", default => $home }
  $root_path = $root ? { '' => "${home_path}/.plenv", default => $root }

  $bin         = "${root_path}/bin"
  $shims       = "${root_path}/shims"
  $versions    = "${root_path}/versions"
  $global_path = "${root_path}/version"
  $path        = [ $shims, $bin, '/bin', '/usr/bin' ]

  # Set Timeout to disabled cause we need a lot of time to compile.
  # Use HOME variable and define PATH correctly.
  exec { "plenv::compile ${user} ${perl}":
    command     => "plenv install ${keep_flag}${perl} && touch ${root_path}/.rehash",
    timeout     => 0,
    user        => $user,
    group       => $group,
    cwd         => $home_path,
    environment => [ "HOME=${home_path}" ],
    creates     => "${versions}/${perl}",
    path        => $path,
    logoutput   => 'on_failure',
    require     => Plenv::Plugin::Perlbuild["plenv::perlbuild ${user}"],
    before      => Exec["plenv::rehash ${user} ${perl}"],
  }

  # Set default global perl version for plenv, if requested
  #
  if $global {
    file { "plenv::global ${user}":
      path    => $global_path,
      content => "${perl}\n",
      owner   => $user,
      group   => $group,
      require => Exec["plenv::compile ${user} ${perl}"]
    }
  }

  plenv::installcpanm { "plenv::installcpanm ${user} ${perl}":
      user => $user,
      perl => $perl,
      home => $home,
      root => $root,
     require => Exec["plenv::compile ${user} ${perl}"]
  }

  exec { "plenv::rehash ${user} ${perl}":
    command     => "plenv rehash && rm -f ${root_path}/.rehash",
    user        => $user,
    group       => $group,
    cwd         => $home_path,
    onlyif      => "[ -e '${root_path}/.rehash' ]",
    environment => [ "HOME=${home_path}" ],
    path        => $path,
    logoutput   => 'on_failure',
  }
}
