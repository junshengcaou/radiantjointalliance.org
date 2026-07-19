module RJA
  class StatePage < Jekyll::PageWithoutAFile
    def initialize(site, base, state_abbr, state_name, entries)
      @site = site
      @base = base
      @dir  = ""
      slug = state_name.downcase.gsub(/[^a-z0-9]+/, '-').gsub(/^-|-$/, '')
      @name = "ldrt-in-#{slug}.html"

      self.process(@name)
      self.data = {
        "layout"      => "state",
        "title"       => "Low-Dose Radiation Therapy (LDRT) in #{state_name} | Radiant Joint Alliance",
        "description" => "Find hospitals and radiation oncology programs offering low-dose radiation therapy (LDRT) for osteoarthritis in #{state_name}.",
        "state_name"  => state_name,
        "state_abbr"  => state_abbr,
        "entries"     => entries,
        "nav"         => "hospitals"
      }
    end
  end

  class CityPage < Jekyll::PageWithoutAFile
    def initialize(site, base, city, state_abbr, state_name, entries)
      @site = site
      @base = base
      @dir  = ""
      slug = "#{city}-#{state_abbr}".downcase.gsub(/[^a-z0-9]+/, '-').gsub(/^-|-$/, '')
      @name = "low-dose-radiation-therapy-in-#{slug}.html"

      self.process(@name)
      self.data = {
        "layout"      => "city",
        "title"       => "Low-Dose Radiation Therapy in #{city}, #{state_abbr} | Radiant Joint Alliance",
        "description" => "Hospitals and radiation oncology programs offering low-dose radiation therapy (LDRT) for osteoarthritis in #{city}, #{state_name}.",
        "city"        => city,
        "state_abbr"  => state_abbr,
        "state_name"  => state_name,
        "entries"     => entries,
        "nav"         => "hospitals"
      }
    end
  end

  class DirectoryPagesGenerator < Jekyll::Generator
    safe true
    priority :normal

    def generate(site)
      directory   = site.data['directory'] || []
      state_names = site.data['state_names'] || {}

      # ---- group by state ----
      by_state = Hash.new { |h, k| h[k] = [] }
      directory.each do |entry|
        st = entry['state']
        by_state[st] << entry if st
      end

      by_state.each do |abbr, entries|
        name = state_names[abbr]
        next unless name
        sorted = entries.sort_by { |e| e['name'] }
        site.pages << StatePage.new(site, site.source, abbr, name, sorted)
      end

      # ---- group by city (only cities with 3+ confirmed listings) ----
      by_city = Hash.new { |h, k| h[k] = [] }
      directory.each do |entry|
        st = entry['state']
        next unless st
        key = [entry['city'], st]
        by_city[key] << entry
      end

      by_city.each do |(city, abbr), entries|
        next if entries.length < 3
        name = state_names[abbr]
        sorted = entries.sort_by { |e| e['name'] }
        site.pages << CityPage.new(site, site.source, city, abbr, name, sorted)
      end
    end
  end
end
