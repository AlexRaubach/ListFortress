xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "ListFortress "
    xml.description "Crowdsourced X-Wing tournaments in order of upload"
    xml.link root_url

    @tournaments.each do |tournament|

      xml.item do
        xml.title tournament.name
        xml.description "#{tournament.participants_count} players battled at #{tournament.location}"
        xml.pubDate tournament.created_at.to_s(:rfc822)
        xml.link tournament_url(tournament)
        xml.guid tournament_url(tournament)
      end
    end
  end
end
