require 'spec_helper'

describe 'plenv::dependencies' do
  let(:title) { 'plenv::dependencies' }

  context 'Ubuntu' do
    let(:facts) { {:osfamily => 'debian'} }
    it { should contain_class('plenv::dependencies::ubuntu') }
  end

  context 'RedHat' do
    let(:facts) { {:osfamily => 'redhat'} }
    it { should contain_class('plenv::dependencies::centos') }
  end

  context 'Suse' do
    let(:facts) { {:osfamily => 'suse'} }
    it { should contain_class('plenv::dependencies::suse') }
  end

  context 'Amazon Linux' do
    let(:facts) { {:osfamily => 'Linux'} }
    it { should contain_class('plenv::dependencies::centos') }
  end
end
