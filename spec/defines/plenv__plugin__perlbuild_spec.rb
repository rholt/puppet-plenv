require 'spec_helper'

describe 'plenv::plugin::perlbuild', :type => :define do
  let :pre_condition do
         'class { "plenv" : }'
  end
  let(:user)      { 'tester' }
  let(:title)     { user }

  it {
    should contain_plenv__plugin("plenv::perlbuild #{user}").with(
      :plugin_name => 'perl-build',
      :source      => 'https://github.com/tokuhirom/Perl-Build.git',
      :user        => user
    )
  }
end
