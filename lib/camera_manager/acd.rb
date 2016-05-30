require 'camera_manager/bin_wrapper'

module CameraManager
  module ACD    
    class File < Struct.new(:key, :name)
      def self.ls
        acd_cli 'sync'

        if block_given?
          acd_cli('ls').each_line do |l|
            file = self.class.parse_acd_output_line l        
            yield file unless file.nil?
          end
        else
          acd_cli('ls').lines.map do |l|
            self.class.parse_acd_output_line l
          end.compact
        end
      end

      def self.ls_hash
        ret = {}

        self.ls.each do |file|
          ret[file.name] = file
        end

        ret
      end
      
      protected

      def self.acd_cli(*args)
        bin.acd_cli(args.join(' '), false)[:stdout]
      end

      def self.bin
        @bin ||= CameraManager::BinWrapper.new
      end
      
      def self.parse_acd_output_line(entry)
        parts = entry.split(' ', 3)

        key = parts.first.gsub(/[\[\]]/, '').strip
        name = parts.last.strip   

        if key.present? && name.present?
          self.new(key, name)
        else
          nil
        end
      end
    end
  end
end

