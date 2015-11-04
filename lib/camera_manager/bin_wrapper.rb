require 'open4'
require 'pty'
require 'camera_manager/utils'

class String
  def last
    if self.length > 0
      self[self.length - 1]
    else
      ""
    end
  end
end

module CameraManager
  class BinWrapper
    include CameraManager::Utils

    def gphotofs_mount(mount_point)
      run "gphotofs #{mount_point}", false
    end

    def rsync(source, destination)
      source = "#{source}/" unless source.last == '/'
      destination = "#{destination}/" unless destination.last == '/'

      run "rsync -av --progress #{source}*.CR2 #{destination}"
    end

    def gphotofs_mounted?(mount_point)
      !! run("mount", false)[:stdout]
        .lines
        .find { |l| l =~ /gphotofs on #{mount_point}/ }
    end

    protected

    def run(cmd, show_output=true)
      begin
        output = nil

        if show_output
          PTY.spawn(cmd) do |r, w, pid|
            r.each { |line| print line }
          end
        else
          stdout_combined = nil
          stderr_combined = nil

          status = Open4::popen4 cmd do |pid, stdin, stdout, stderr|
            stdout_combined = stdout.read
            stderr_combined = stderr.read
          end

          {
            status: status,
            stdout: stdout_combined,
            stderr: stderr_combined
          }
        end
      rescue Errno::ENOENT
        bail "#{cmd} binary not found"
      end
    end
  end
end

