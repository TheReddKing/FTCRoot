
base_url = "http://www.ftcroot.com"
xml.instruct! :xml, :version=>'1.0'
xml.tag! 'urlset', 'xmlns' => 'http://www.sitemaps.org/schemas/sitemap/0.9' do
  xml.url{
      xml.loc(base_url)
      xml.changefreq("weekly")
      xml.priority(1.0)
  }
    xml.url{
        xml.loc(base_url + "/teams")
        xml.changefreq("weekly")
        xml.priority(1.0)
    }
      xml.url{
          xml.loc(base_url + "/map")
          xml.changefreq("weekly")
          xml.priority(1.0)
      }

  xml.url{
      xml.loc(base_url + "/events")
      xml.changefreq("weekly")
      xml.priority(1.0)
  }

    xml.url{
        xml.loc(base_url + "/search")
        xml.changefreq("weekly")
        xml.priority(1.0)
    }
    xml.url {
        xml.loc(base_url + "/pages/usefultools")
        xml.changefreq("weekly")
        xml.priority(1.0)
    }
  # xml.url{
  #     xml.loc(base_url + "/swimmers")
  #     xml.changefreq("weekly")
  #     xml.priority(0.9)
  # }
  @teams.each do |team|
    xml.url {
      xml.loc(base_url + "/teams/" + team.id.to_s + "/" + team.name.gsub(/[^A-Za-z0-9_ ]/,"").gsub(" ","_"))
      xml.changefreq("monthly")
      xml.priority(0.4)
    }
  end
  @meets.each do |meet|
    xml.url {
      xml.loc(base_url + "/events/" + meet.id.to_s + "/" + meet.name.gsub(/[^A-Za-z0-9_ ]/,"").gsub(" ","_"))
      xml.changefreq("monthly")
      xml.priority(0.2)
    }
  end
end
