class Tagging < ActiveRecord::Base
  include Cacheable

  # Relationships
  belongs_to :tag, :counter_cache => true
  belongs_to :snippet, :counter_cache => true

  # Validations
  validates_uniqueness_of :tag_id, :scope => :snippet_id
end
