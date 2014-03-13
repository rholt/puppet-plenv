define plenv::plugin(
  $user,
  $source,
  $plugin_name = $title,
  $group       = $user,
  $home        = $::plenv::default_home_path,
  $root        = $::plenv::default_root_path,
  $timeout     = $::plenv::default_exec_timeout
) {

  if !defined(Class['plenv']) {
    fail('You must include the plenv base class before using any plenv defined resource types')
  }

  if $source !~ /^(git|https):/ {
    fail('Only git plugins are supported')
  }

  $home_path   = $home ? { '' => "/home/${user}",       default => $home }
  $root_path   = $root ? { '' => "${home_path}/.plenv", default => $root }
  $plugins     = "${root_path}/plugins"
  $destination = "${plugins}/${plugin_name}"

  if ! defined(File["plenv::plugins ${user}"]) {
    file { "plenv::plugins ${user}":
      ensure  => directory,
      path    => $plugins,
      owner   => $user,
      group   => $group,
      require => Exec["plenv::checkout ${user}"],
    }
  }

  exec { "plenv::plugin::checkout ${user} ${plugin_name}":
    command => "git clone ${source} ${destination}",
    user    => $user,
    group   => $group,
    creates => $destination,
    path    => ['/bin', '/usr/bin', '/usr/sbin'],
    timeout => $timeout,
    cwd     => $home_path,
    require => File["plenv::plugins ${user}"],
  }

  exec { "plenv::plugin::update ${user} ${plugin_name}":
    command => 'git pull',
    user    => $user,
    group   => $group,
    path    => ['/bin', '/usr/bin', '/usr/sbin'],
    timeout => $timeout,
    cwd     => $destination,
    require => Exec["plenv::plugin::checkout ${user} ${plugin_name}"],
  }

}
