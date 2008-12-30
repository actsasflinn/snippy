# Ensure cache keys do not contain spaces
class MemCache
  def make_cache_key_with_underscore(key)
    make_cache_key_without_underscore(key.gsub(' ', '_'))
  end
  alias_method_chain :make_cache_key, :underscore
end