require 'camera_manager/bin_wrapper'

class NilClass
  def present?
    false
  end
end

class String
  def present?
    self.length > 0
  end
end

module CameraManager
  module ACD
    class File < Struct.new(:key, :name)
      def self.ls
        acd_cli 'sync'

        if block_given?
          acd_cli('ls').each_line do |l|
            file = self.parse_acd_output_line l
            yield file unless file.nil?
          end
        else
          acd_cli('ls').lines.map do |l|
            self.parse_acd_output_line l
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
        output = bin.acd_cli(args)

        if output[:stderr]
          $stderr.puts output[:stderr]
        end

        output[:stdout]
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
