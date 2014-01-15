define plenv::definition(
  $user,
  $source,
  $perl  = $title,
  $group = $user,
  $home  = '',
  $root  = ''
) {

  $home_path = $home ? { '' => "/home/${user}",       default => $home }
  $root_path = $root ? { '' => "${home_path}/.plenv", default => $root }

  $destination = "${root_path}/plugins/perl-build/share/perl-build/${perl}"

  if $source =~ /^puppet:/ {
    file { "plenv::definition-file ${user} ${perl}":
      ensure  => file,
      source  => $source,
      group   => $group,
      path    => $destination,
      require => Exec["plenv::plugin::checkout ${user} perl-build"],
    }
  } elsif $source =~ /http(s)?:/ {
    exec { "plenv::definition-file ${user} ${perl}":
      command => "wget ${source} -O ${destination}",
      creates => $destination,
      user    => $user,
      require => Exec["plenv::plugin::checkout ${user} perl-build"],
    }
  }
}
