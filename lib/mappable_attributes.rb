module MappableAttributes
  require 'rubygems'
  require 'active_support/concern'
  require 'active_support/core_ext/class/attribute'
  require 'active_support/core_ext/object/blank'
  require 'active_support/core_ext/hash/indifferent_access'  
  require 'active_support/core_ext/module/aliasing'
  require 'active_support/inflector'  
  
  autoload :Base, 'mappable_attributes/base'
end
