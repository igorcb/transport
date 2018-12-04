require 'open3'

require_relative 'utils'

module Clipboard
  module Linux
    extend self

    CLIPBOARDS = %w[clipboard primary secondary].freeze

    # check which backend to use
    if Utils.executable_installed?('xclip')
      WriteCommand = 'xclip'.freeze
      ReadCommand  = 'xclip -o'.freeze
      Selection    = proc{ |x| "-selection #{x}" }.freeze
    elsif Utils.executable_installed?('xsel')
      WriteCommand = 'xsel -i'.freeze
      ReadCommand  = 'xsel -o'.freeze
      Selection    = { 'clipboard' => '-b', 'primary' => '-p', 'secondary' => '-s' }.freeze
    else
      raise Clipboard::ClipboardLoadError, "clipboard: Could not find required program xclip or xsel\n" \
            "On debian/ubuntu, you can install it with: sudo apt-get install xclip"
    end

    def paste(which = nil)
      if !which || !CLIPBOARDS.include?(which.to_s.downcase)
        which = CLIPBOARDS.first
      end
      `#{ReadCommand} #{Selection[which.to_s.downcase]} 2> /dev/null`
    end

    def clear
      copy ''
    end

    def copy(data)
      CLIPBOARDS.each{ |which|
        Open3.popen3( "#{WriteCommand} #{Selection[which.to_s.downcase]}" ){ |input, _, _| input << data }
      }
      paste
    end
  end
end
