class Snippet < ActiveRecord::Base
  include Cacheable

  # Class Attributes
  cattr_accessor :per_page
  @@per_page = 10

  # Attributes
  attr_protected :user_id
  attr_protected :formatted_body

  # Plugins
  acts_as_snook
  define_index do
    indexes :body
    indexes language.name, :as => :language
    indexes tags.name, :as => :tag
  end

  # Relationships
  belongs_to :language, :counter_cache => true
  has_many :taggings
  has_many :tags, :through => :taggings

  # Validations
  validates_length_of :body, :minimum => 1
  validates_presence_of :language_id

  # Scopes
  named_scope :language, lambda{ |language_id| { :conditions => language_id.blank? ? nil : { :language_id => language_id } } }
  named_scope :tag, lambda{ |tag_id| { :conditions => tag_id.blank? ? nil : { "taggings.tag_id" => tag_id } } }

  # Callbacks
  before_validation_on_update :calculate_snook_score
  before_save :format_body
  before_save :format_preview

  def format_body
    self.formatted_body = Uv.parse(self.body, "xhtml", self.language.slug, false, "clean")
  end

  def format_preview
    self.formatted_preview = Uv.parse(self.preview, "xhtml", self.language.slug, false, "clean")
  end

  def preview
    self.body.split("\n")[0..4].join("\n")
  end
end
