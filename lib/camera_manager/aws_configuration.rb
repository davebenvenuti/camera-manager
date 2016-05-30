module CameraManager
  class AWSConfiguration
    attr_reader :filename
    attr_reader :aws_access_key_id
    attr_reader :aws_secret_access_key

    def initialize(filename=File.expand_path("~/.aws/credentials"))
      @filename = filename

      # TODO support multiple config entries
      self.config_file_contents.each_line do |line|
        if line =~ /^aws_access_key_id\w*\=\w*(.*)$/
          @aws_access_key_id = $1
        elsif line =~ /^aws_secret_access_key\w*\=\w*(.*)$/
          @aws_secret_access_key = $1
        end
      end
    end

    def config_file_contents
      @config_file_contents ||= File.read(@filename)
    end
  end
end
