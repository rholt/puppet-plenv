require 'spec_helper'

describe 'plenv::cpanm', :type => :define do
  # User must be unique to this spec so that our fixture doesn't break other specs.
  # User and version must match what's in the Exec[plenv::compile...] 
  # in spec/fixtures/manifests/site.pp so that the 'is this perl installed' test
  # in plenvcpanm.pp will pass.
  let(:user)           { 'cpanm_tester' }
  let(:perl_version)   { '5.10.1' }
  let(:title)          { 'somecpanm' }
  let(:cpanm_name)       { params[:cpanm] || title }
  let(:plenv)          { "/home/#{user}/.plenv/versions/#{perl_version}" }
  let(:_ensure)        { params[:ensure] || 'present' }
  let(:source)         { params[:source] || '' }
  let(:default_params) { {:user => user, :perl => perl_version } }
  let(:params)         { default_params.merge(@params) }

  before do
    @params = {}
  end

  describe 'when the perl version has not been installed' do
    let(:perl_version) { '0.0.0' } 
    it 'fails' do
      expect {
        should contain_class('foo')
      }.to raise_error(Puppet::Error, /Plenv-Perl #{perl_version} for user #{user} not found in catalog/)
    end
  end

  shared_examples 'plenvcpanm' do
    it { 
      should contain_plenvcpanm("#{user}/#{perl_version}/#{cpanm_name}/#{_ensure}").with(
        'ensure' => _ensure,
        'user' => params[:user],
        'cpanmname' => cpanm_name,
        'perl' => params[:perl],
        'plenv' => plenv,
        'source' => source
    ) 
    }
        end

  it_behaves_like "plenvcpanm"

  describe "when there is a source param" do
    before do
      @params[:source] = 'foo'
    end
    it_behaves_like "plenvcpanm"
  end

  describe "when there is an ensure param" do
    before do
      @params[:ensure] = 'absent'
    end
    it_behaves_like "plenvcpanm"
    end

  describe "when there is a cpanm param" do
    before do
      @params[:cpanm] = 'some-other-cpanm'
    end
    it_behaves_like "plenvcpanm"
  end

  describe "when there is a home param" do
    before do
      @params[:home] = '/usr/local/foo'
    end
    let(:plenv) { "#{params[:home]}/.plenv/versions/#{perl_version}" }
    it_behaves_like "plenvcpanm"
  end

  describe "when there is a root param" do
    let(:plenv) { "#{params[:root]}/versions/#{perl_version}" }
    before do
      @params[:root] = '/usr/local/bar/.plenv'
    end
    it_behaves_like "plenvcpanm"

    describe "when there is both a home and a root param the root takes precedence" do
      before do
        @params[:home] = '/usr/local/foo'
      end
      it_behaves_like "plenvcpanm"
    end
  end

end
