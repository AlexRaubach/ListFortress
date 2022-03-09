class Format < ApplicationRecord
  has_many :tournaments
# This class holds tournament formats
# The sort field both controls the order they're sorted in but also allows them to be depricated.
# if sort = null, you can't select them in the tournament create form but can still filter by the format
# Note that the nulls last sort in app/views/tournaments/_filter.html.erb is postgres only
end
