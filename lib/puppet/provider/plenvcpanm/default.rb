Puppet::Type.type(:plenvcpanm).provide :default do
  desc "Maintains cpan modules inside a plenv setup"

  commands :su => 'su'

  def install
    args = [ module_name , version_string ]
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

    def version_string
	  resource[:version]
	end

    def module_name
      resource[:module]
    end

    def cpanm(*args)
      exe =  "PLENV_VERSION=#{resource[:perl]} cpanm"
      su('-', resource[:user], '-c', [exe, *args].join(' '))
    end

    def list(where = :local)
      args = [];
      exe = where == :remote ? "PLENV_VERSION=#{resource[:perl]} cpanm --info #{module_name}" : "PLENV_VERSION=#{resource[:perl]} perl -M#{module_name} -e 'print \"#{module_name}-\" . \$#{module_name}::VERSION;'"
      begin 
       
	   ver = ''

       su('-', resource[:user], '-c', [exe, *args].join(' ')).lines.map do |line|
         line.gsub!(/\-/,' ')
         line =~ /^(?:\S+)\s+(v*[\.0-9_]+[0-9]+)/
         puts $2
         return nil unless $1

         # Fetch the version number
         ver = $1.split(/,\s*/)
	     puts ver
         ver.empty? ? nil : ver
       end.first
	 
	 rescue
	    ver.empty? ? nil : ver
	 end

   end
end
