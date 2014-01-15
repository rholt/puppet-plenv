define plenv::plugin::plenvvars(
  $user   = $title,
  $source = 'https://github.com/sstephenson/plenv-vars.git',
  $group  = $user,
  $home   = '',
  $root   = ''
) {
  plenv::plugin { "plenv::plugin::plenvvars::${user}":
    user        => $user,
    source      => $source,
    plugin_name => 'plenv-vars',
    group       => $group,
    home        => $home,
    root        => $root
  }
}
