define plenv::plugin(
  $user,
  $source,
  $plugin_name = $title,
  $group       = $user,
  $home        = '',
  $root        = '',
  $timeout     = 100
) {

  $home_path   = $home ? { '' => "/home/${user}",       default => $home }
  $root_path   = $root ? { '' => "${home_path}/.plenv", default => $root }
  $plugins     = "${root_path}/plugins"
  $destination = "${plugins}/${plugin_name}"

  if $source !~ /^(git|https):/ {
    fail('Only git plugins are supported')
  }

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
