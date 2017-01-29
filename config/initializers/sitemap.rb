SitemapGenerator::Sitemap.default_host = 'https://ftcroot.herokuapp.com'
SitemapGenerator::Sitemap.create do
  add '/', :changefreq => 'weekly', :priority => 0.9
  add '/pages/usefultools', :changefreq => 'weekly'
  add '/events', :changefreq => 'weekly'
  add '/teams', :changefreq => 'weekly'
  add '/search', :changefreq => 'weekly'
  add '/pages/about', :changefreq => 'weekly'
end
# SitemapGenerator::Sitemap.ping_search_engines # Not needed if you use the rake tasks
