require 'singleton'
require 'camera_manager/configurable'
require 'camera_manager/utils'

module CameraManager
  class Config
    include Singleton
    include CameraManager::Configurable
    include CameraManager::Utils

    yml_file File.expand_path("~/.camera_manager.yml")

    config_value :mount_path, "Mount path"
    config_value :photos_path, "Photo storage/destination path"

    # Dig into the mount point so we have the base folder where the images
    # actually are
    #
    # TODO move this to CLI
    def camera_images_path
      @camera_images_path ||= begin
                                glob = File.expand_path(File.join(
                                                         self.mount_path,
                                                         "store_*/DCIM/*/"
                                                       ))

                                path = Dir[glob].first

                                if path && File.directory?(path)
                                  path
                                else
                                  bail "Unrecognized folder structure in #{self.mount_path}"
                                end
                              end
    end
  end
end

