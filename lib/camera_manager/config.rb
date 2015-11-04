require 'singleton'
require 'camera_manager/configurable'

module CameraManager
  class Config
    include Singleton
    include CameraManager::Configurable

    yml_file File.expand_path("~/.camera_manager.yml")

    config_value :mount_path, "Mount path"
    config_value :photos_path, "Photo storage/destination path"
  end
end

