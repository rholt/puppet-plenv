Puppet::Type.type(:plenvcpanm).provide :default do
  desc "Maintains cpan modules inside a plenv setup"

  commands :su => 'su'

  def install
    args = ['install']
    #args << "-v#{resource[:ensure]}" if !resource[:ensure].kind_of?(Symbol)
    #args << [ '--source', "'#{resource[:source]}'" ] if resource[:source] != ''
    args << module_name
    output = cpanm(*args)
    fail "Could not install: #{output.chomp}" if output.include?('ERROR')
  end

  def uninstall
    cpanm 'uninstall', module_name
  end

  def latest
    @latest ||= list(:remote)
  end

  def current
    list
  end

  private
    def module_name
      resource[:module]
    end

    def cpanm(*args)
      exe =  "PLENV_VERSION=#{resource[:perl]} " + resource[:plenv] + 'cpanm'
      su('-', resource[:user], '-c', [exe, *args].join(' '))
    end

    def list(where = :local)
      args = ['list', "#{module_name}$" ]
      #args = ['list', where == :remote ? '--remote' : '--local', "#{module}$"]

      cpanm(*args).lines.map do |line|
        line =~ /^(?:\S+)\s+\((.+)\)/

        return nil unless $1

        # Fetch the version number
        ver = $1.split(/,\s*/)
        ver.empty? ? nil : ver
      end.first
    end
end
