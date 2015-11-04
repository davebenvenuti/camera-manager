module CameraManager
  module Utils
    protected

    def bail(message)
      $stderr.puts message

      exit 1
    end
  end
end

