defmodule SizeGuard do
  defguard is_small(len) when is_integer(len) and len > 0 and len <= 4
  defguard is_medium(len) when is_integer(len) and len >= 5 and len <= 12
  defguard is_large(len) when is_integer(len) and len >= 13
end
