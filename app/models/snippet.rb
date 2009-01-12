class Snippet
  include DataMapper::Resource

  # Properties
  property :id, Serial
  property :author, String
  property :email, String
  property :url, String
  property :body, Text
  property :language_id, Integer
  property :created_at, DateTime
  property :updated_at, DateTime

  # Relationships
  belongs_to :language

  # Validations
  validates_present :body, :language_id

  alias_method :to_text, :body

  def preview
    body.split("\n").first(5).join("\n")
  end
end
