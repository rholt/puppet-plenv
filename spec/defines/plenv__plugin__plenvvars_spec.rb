require 'spec_helper'

describe 'plenv::plugin::plenvvars', :type => :define do
  let(:user)      { 'tester' }
  let(:title)     { user }

  it {
    should contain_plenv__plugin("plenv::plugin::plenvvars::#{user}").with(
      :plugin_name => 'plenv-vars',
      :source      => 'https://github.com/tokuhirom/plenv-vars.git',
      :user        => user
    )
  }
end
