# The following part compiles and installs the chosen perl version,
# using the "perl-build" plenv plugin.
#
define plenv::compile(
  $user,
  $perl           = $title,
  $group          = $user,
  $home           = '',
  $root           = '',
  $source         = '',
  $global         = false,
  $keep           = false,
  $configure_opts = '--disable-install-doc',
  $bundler        = present,
) {

  $home_path = $home ? { '' => "/home/${user}", default => $home }
  $root_path = $root ? { '' => "${home_path}/.plenv", default => $root }

  $bin         = "${root_path}/bin"
  $shims       = "${root_path}/shims"
  $versions    = "${root_path}/versions"
  $global_path = "${root_path}/version"
  $path        = [ $shims, $bin, '/bin', '/usr/bin' ]

  # Keep flag saves source tree after building.
  # This is required for some modules (e.g. debugger)
  if $keep {
    $keep_flag = '--keep '
  }
  else {
    $keep_flag = ''
  }

  if ! defined( Class['plenv::dependencies'] ) {
    require plenv::dependencies
  }

  # If no perl-build has been specified and the default resource hasn't been
  # parsed
  $custom_or_default = Plenv::Plugin["plenv::plugin::perlbuild::${user}"]
  $default           = Plenv::Plugin::Perlbuild["plenv::perlbuild::${user}"]
  if ! defined($custom_or_default) and ! defined($default) {
    debug("No perl-build found for ${user}, going to add the default one")
    plenv::plugin::perlbuild { "plenv::perlbuild::${user}":
      user   => $user,
      group  => $group,
      home   => $home,
      root   => $root
    }
  }

  if $source {
    plenv::definition { "plenv::definition ${user} ${perl}":
      user    => $user,
      group   => $group,
      source  => $source,
      perl    => $perl,
      home    => $home,
      root    => $root,
      require => Plenv::Plugin["plenv::plugin::perlbuild::${user}"],
      before  => Exec["plenv::compile ${user} ${perl}"]
    }
  }

  # Set Timeout to disabled cause we need a lot of time to compile.
  # Use HOME variable and define PATH correctly.
  exec { "plenv::compile ${user} ${perl}":
    command     => "plenv install ${keep_flag}${perl} && touch ${root_path}/.rehash",
    timeout     => 0,
    user        => $user,
    group       => $group,
    cwd         => $home_path,
    environment => [ "HOME=${home_path}", "CONFIGURE_OPTS=${configure_opts}" ],
    creates     => "${versions}/${perl}",
    path        => $path,
    logoutput   => 'on_failure',
    require     => Rbenv::Plugin["plenv::plugin::perlbuild::${user}"],
    before      => Exec["plenv::rehash ${user} ${perl}"],
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

  # Install bundler
  #
  plenv::gem {"plenv::bundler ${user} ${perl}":
    ensure => $bundler,
    user   => $user,
    perl   => $perl,
    gem    => 'bundler',
    home   => $home_path,
    root   => $root_path,
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
}
