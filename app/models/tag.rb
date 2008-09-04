class Tag < ActiveRecord::Base
  include ActionView::Helpers::SanitizeHelper

  # Plugins
  define_index do
    indexes :name
  end

  # Relationships
  has_many :taggings
  has_many :snippets, :through => :taggings

  # Validations
  validates_uniqueness_of :name

  # Callbacks
  before_save :strip_tags_name

  # Scopes
  named_scope :without_snippet_id, lambda{ |snippet_id| { :conditions => ["taggings.snippet_id != ? OR taggings_count = 0", snippet_id], :include => :taggings } }
  named_scope :with_snippets, :conditions => "taggings_count > 0"

  def strip_tags_name
    self.name = strip_tags(self.name)
  end

  def score
    tag_score = self.taggings_count / 5 # base on 5
    tag_score > 10 ? 10 : tag_score     # limit the score to 10
  end
end
