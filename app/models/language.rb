class Language
  include DataMapper::Resource

  # Properties
  property :id, Serial
  property :name, String, :nullable => false, :unique => true
  property :slug, String, :nullable => false, :unique => true
  property :updated_at, DateTime
  property :created_at, DateTime

  # Relationships
  has n, :snippets

  # Callbacks
  before :valid?, :set_slug

  def slugify
    self.name.downcase.gsub(/[^a-z0-9_ -]/,"").strip.gsub(/( )/,"-").gsub(/-{2,}/,"-")
  end

  def set_slug
    self.slug = slugify if slug.blank?
  end
end
