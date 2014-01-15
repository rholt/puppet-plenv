require 'spec_helper'

describe 'plenv::plugin', :type => :define do
  let(:user)        { 'tester' }
  let(:plugin_name) { 'plenv-vars' }
  let(:dot_plenv)   { "/home/#{user}/.plenv" }
  let(:source)      { 'https://github.com/plenv/plugin' }
  let(:title)       { "plenv::plugin::#{user}::#{plugin_name}" }
  let(:params)      { {:user => user, :plugin_name => plugin_name, :source => source} }

  let(:target_path) { "#{dot_plenv}/plugins/#{plugin_name}" }

  it 'clones repository to the right path' do
    should contain_exec("plenv::plugin::checkout #{user} #{plugin_name}").with(
      :command => "git clone #{source} #{target_path}",
      :user    => user,
      :creates => target_path,
      :require => /plenv::plugins #{user}/,
      :path    => ['/bin','/usr/bin','/usr/sbin']
    )
  end

  it 'pulls the latest plugin changes from their git repos' do
    should contain_exec("plenv::plugin::update #{user} #{plugin_name}").with(
      :command => 'git pull',
      :user    => user,
      :cwd     => target_path,
      :require => /plenv::plugin::checkout #{user} #{plugin_name}/,
      :path    => ['/bin','/usr/bin','/usr/sbin']
    )
  end

  context 'with source != git' do
    let(:source) { 'something != git' }

    it 'fails informing that it is not supported yet' do
      expect {
        should contain_exec("plenv::plugin::checkout #{user} #{plugin_name}")
      }.to raise_error(Puppet::Error, /Only git plugins are supported/)
    end
  end
end
