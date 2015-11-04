require 'highline/import'
require 'yaml'

class Hash
  def stringify_keys
    result = {}
    self.each do |key, value|
      result[key.to_s] = value
    end

    result
  end

  def symbolize_keys
    result = {}
    self.each do |key, value|
      result[key.to_sym] = value
    end

    result
  end
end

module CameraManager
  module Configurable
    def self.included(includer)
      includer.send :extend, CameraManager::Configurable::ClassMethods
    end

    def save!
      File.open self.class.yml_file, 'w' do |f|
        f.print YAML.dump(self.contents.stringify_keys)
      end

      @dirty = false

      self.class.yml_file
    end

    def dirty?
      !!@dirty
    end

    protected

    def contents
      @contents ||= begin
                      if File.exists? self.class.yml_file
                        c = YAML.load_file self.class.yml_file

                        c.is_a?(Hash) ? c.symbolize_keys : {}
                      else
                        {}
                      end
                    end
    end

    def dirty!
      @dirty = true
    end

    def prompt_for(name, description)
      val = nil

      while val.nil? || (val.length == 0)
        val = ask "#{description}: "
      end

      self.send "#{name}=", val

      self.save!

      val
    end

    module ClassMethods
      def yml_file(path=nil)
        path.nil? ? @path : (@path = path)
      end

      def config_value(name, description=nil)
        description ||= name

        define_method name do
          if self.contents.has_key? name
            self.contents[name]
          else
            prompt_for name, description
          end
        end

        define_method "#{name}=" do |val|
          self.dirty!

          self.contents[name] = val
        end
      end      
    end
  end
end

