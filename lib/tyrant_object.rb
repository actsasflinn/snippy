require 'extlib'
require 'json'

module TyrantObject
  def self.included(base)
    super
#    base.send(:attr_accessor, :attributes)
    base.send(:cattr_accessor, :properties)
    base.send('properties=', Mash.new())
    base.extend(ClassMethods)
  end

  def self.boolean
    proc{ |v|
      return true if v.is_a?(TrueClass)
      return false if v.is_a?(FalseClass)
      v.to_i == 0 ? false : true
    }
  end

  def self.time
    proc{ |v|
      return v if v.is_a?(Time)
      v.nil? ? Time.now : Time.parse(v)
    }
  end

  module ClassMethods
    def [](id)
      record = tyrant[id]
      new(record) unless record.nil?
    end

    def []=(*args)
      value = args.pop
      value['id'] = args.first || value['id'] # if there is a first argument use it
      value['id'] ||= tyrant.genuid           # if both the key and :id are blank make one
      tyrant[value['id']] = value.to_h
      value
    end

    def paginate(options = {})
      page = (options.delete(:page) || 1).to_i
      limit = 20
      offset = (page - 1) * 20
      return [] if offset >= count
      last = offset + (limit - 1)
#      page_keys = tyrant.keys.slice(offset..last)
#      page_keys.collect{ |key| tyrant[key] }
      recs = tyrant.mget(offset..last)
      recs.sort{ |x,y| x[0] <=> y[0] }.collect{ |row| row[1] }
    end

    def method_missing(name, *args, &block)
      if tyrant.methods.include?(name.id2name)
        tyrant.send(name, *args, &block)
      else
        super
      end
    end
  end

  def initialize(attributes = {})
    @attributes = Mash.new
    assign_attributes(attributes)
    self.class[] = self if new_record?
  end

  def new_record?
    @attributes[:id].nil?
  end

  def attributes=(h)
    assign_attributes(h)
    self.class[] = self
  end

  def assign_attributes(h)
    m = Mash.new(@attributes.merge(h))
    columns.each_pair{ |p,t| self[p] = m[p] }
  end

  def [](attr)
    @attributes[attr]
  end

  def []=(attr, v)
    raise "No property! '#{attr}'" if columns[attr].nil?
    unless columns[attr].respond_to?(:call)
      if v.is_a?(columns[attr])
        @attributes[attr] = v
      else
        @attributes[attr] = v.nil? ? nil : send(columns[attr].name, v)
      end
    else
      @attributes[attr] = columns[attr].call(v)
    end
  end

  # probably should be class level
  def columns
    Mash.new(self.class.properties)
  end

  def to_h
    Mash.new(@attributes)
  end

  def to_json
    to_h.to_json
  end
end

# ugh, as this evolves it starts to look a lot like ar / dm
# might as well not fight it and just go with a DM adapter