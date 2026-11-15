class Roundtype < ApplicationRecord
  # Seeded ids that the app relies on (see Round#sort_value and tournaments/show).
  SWISS_ID = 1
  ELIMINATION_ID = 2
end
