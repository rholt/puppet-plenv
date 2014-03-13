class plenv::params {

 $plenvrc_template       = 'plenv/dot.plenvrc.erb'
 $cpanfile_template      = 'plenv/cpanfile.erb'
 $plenv_git_url          = 'https://github.com/tokuhirom/plenv.git'
 $local_bash_profile     = '.bash_profile'
 $default_paths          = ['/bin', '/usr/bin', '/usr/sbin']
 $default_exec_timeout   = 100
 $default_root_path      = ''
 $default_home_path      = ''
 $default_cpan_modules   = ''
 $default_cpanfile_content = ''
 $carton_lock_file       = 'cpanfile.lock'
 $cpanfile_name          = 'cpanfile'

}
