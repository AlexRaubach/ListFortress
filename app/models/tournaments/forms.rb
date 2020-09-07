# frozen_string_literal: true

module Tournaments
  class Forms
    ORDER = {
      # simple name for key, then array with sql string and the display text
      # each sort needs to be completely unique. If you have ties in the order, the pagination can hide some tournaments
      'date_desc' => ['date desc, id desc', 'Newest'],
      'date_asc' => ['date asc, id desc', 'Oldest'],
      'size_desc' => ['participants_count desc, id desc', 'Largest'],
      'size_asc' => ['participants_count asc, id desc', 'Smallest']
    }.freeze
  end
end
