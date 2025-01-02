desc "This task is called by the Heroku scheduler add-on"

task :item_download => :environment do
  circuitree = Circuitree::ApiDownload.item_download
end

task :circuitree_download => :environment do
  circuitree = Circuitree::ApiDownload.circuitree_download
end

task :program_download => :environment do
  circuitree = Circuitree::ApiDownload.program_download
end

task :set_internal => :environment do
  circuitree = Circuitree::ApiDownload.set_internal
end

task :create_item_abbreviations => :environment do
  circuitree = Circuitree::ApiDownload.create_item_abbreviations
end