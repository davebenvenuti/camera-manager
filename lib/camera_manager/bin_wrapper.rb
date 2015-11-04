require 'open4'
require 'camera_manager/utils'

module CameraManager
  class BinWrapper
    include CameraWrapper::Utils

    def gphotofs_mount(mount_point)
      run "gphotofs #{mount_point}"
    end

    def rsync(source, destination)
      run "rsync #{source} #{destination}"
    end

    def gphotofs_mounted?(mount_point)
      run("mount", false)[:output]
        .lines
        .find { |l| l =~ /gvfsd-fuse on #{mount_point}/ }
        .length > 0
    end

    protected

    def run(cmd, show_output=true)
      begin
        output = nil

        status = Open4::popen4 cmd do |pid, stdin, stdout, stderr|
          if show_output
            stdout.each do |line|
              puts stdout
            end

            Thread.new {
              stderr.each do |line|
                $stderr.puts line
              end
            }.join
          else
            output = stdout.read + stderr.read
          end
        end

        if output
          { status: status, output: output }
        else
          status
        end
      rescue Errno::ENOENT
        bail "#{cmd} binary not found"
      end
    end
  end
end

