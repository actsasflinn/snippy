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

  module ClassMethods
    def [](id)
      record = $tyrant[id]
      new(record) unless record.nil?
    end

    def []=(*args)
      value = args.pop
      value['id'] = args.first || value['id'] # if there is a first argument use it
      value['id'] ||= $tyrant.genuid         # if both the key and :id are blank make one
      $tyrant[value['id']] = value.to_h
      value
    end
  end

  def initialize(attributes)
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
    @attributes[attr] = v.nil? ? nil : send(columns[attr].name, v)
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