# Fix for infinite waits on TCP Socket timeouts
# From http://blog.rapleaf.com/dev/?p=14
require "timeout"

class MemCache
  alias_method :old_get, :get
  alias_method :old_set, :set
  alias_method :old_incr, :incr
  alias_method :old_add, :add
  alias_method :old_delete, :delete  
  alias_method :old_get_multi, :get_multi

  def get(key, raw = false, timeout = 1.0)
    Timeout::timeout(timeout) do
      old_get(key, raw)
    end
  rescue Timeout::Error
    nil
  end

  def set(key, value, expiry = 0, raw = false, timeout = 1.0)
    Timeout::timeout(timeout) do
      old_set(key, value, expiry, raw)
    end
  end

  def incr(key, amount = 1, timeout = 1.0)
    Timeout::timeout(timeout) do
      old_incr(key, amount)
    end
  end

  def add(key, value, expiry = 0, raw = false, timeout = 1.0)
    Timeout::timeout(timeout) do
      old_add(key, value, expiry, raw)
    end
  end

  def delete(key, expiry = 0, timeout = 1.0)
    Timeout::timeout(timeout) do
      old_delete(key, expiry)
    end
  end

  def get_multi(*args)
    if args.last.is_a?(Float) || args.last.is_a?(Fixnum)
      # assume it's a timeout
      timeout = args.pop
      Timeout::timeout(timeout) do
        old_get_multi(*args)
      end
    else
      Timeout::timeout(15) do
        old_get_multi(*args)
      end
    end
  rescue Timeout::Error
    {}
  end
end