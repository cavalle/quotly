class AutocompletePresenter < Presenter

  def self.search_set(name, q)
    Redis::SortedSet.new("autocomplete_presenter:#{name}:#{q.downcase}")
  end

  def self.search_sources(q)
    search_set(:sources, q).members
  end

  def self.search_authors(q)
    search_set(:authors, q).members
  end

  on :quote_added do |event|
    index :sources, event[:source]
    index :authors, event[:author]
  end

  def self.index(set, value)
    if value.present?
      value.split(/\s+/).each_with_index do |word, rank|
        (2..word.length - 1).each do |i|
          q = word[0..i]
          search_set(set, q)[value] = rank
        end
      end
    end
  end
end
