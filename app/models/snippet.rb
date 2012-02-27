class Snippet < ActiveRecord::Base
  # Class Attributes
  cattr_accessor :per_page
  @@per_page = 10

  # Attributes
  attr_protected :user_id
  attr_protected :formatted_body

  # Plugins
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
  scope :language, lambda{ |language_id| { :conditions => language_id.blank? ? nil : { :language_id => language_id } } }
  scope :tag, lambda{ |tag_id| { :conditions => tag_id.blank? ? nil : { "taggings.tag_id" => tag_id } } }

  # Callbacks
  before_save :format_body
  before_save :format_preview

  def format_body
    self.formatted_body = Uv.parse(body, "xhtml", language.syntax, false, "clean")
  end

  def format_preview
    self.formatted_preview = Uv.parse(preview, "xhtml", language.syntax, false, "clean")
  end

  def preview
    body.split("\n")[0..4].join("\n")
  end

  def theme
    attributes['theme'] || DEFAULT_THEME
  end
end
