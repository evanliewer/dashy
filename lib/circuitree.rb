module Circuitree

 class ApiDownload

  def self.item_download
    Team.all.each do |team|  
        puts "CTquery method from CT library module"
        url = "https://api.circuitree.com/Exports/ExecuteQuery.json"
        puts "CT Query is: #{team.item_query}"
        paramArray = []
        data = {
          'ApiToken' => team.circuitree_api,
          'ExportQueryID' => team.item_query,
          'QueryParameters' => paramArray
        }

        uri = URI(url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
        req.body = data.to_json
        res = http.request(req)
        ct_results = JSON.parse(res.body)

      puts "Begin Item Download"
      puts "Items in Camp Dashboard go after CT definition of active"
       ct_results.each do |key,value|
        if key == "Results"
          JSON.parse(value).each do |val|
           begin 
            item = Item.find_or_create_by(:id => val['ResourceID'].to_s)
              item.id = val['ResourceID'].to_s
              item.name = val['Name'].to_s
              item.team_id = team.id
              item.description = val['Description'].to_s
                if val['Active'].to_i == 1
                  item.active ||= true
                end 
            item.save
            puts item.name

            #Creating tags for division
            item_tag = Items::Tag.find_or_create_by(team_id: team.id, name: val['Division'])
            item_tag.save
            applied_tag = Items::AppliedTag.find_or_create_by(tag_id: item_tag.id, item_id: item.id)
            applied_tag.save
            #Creating tags for Category
            item_tag = Items::Tag.find_or_create_by(team_id: team.id, name: val['Category'])
            item_tag.save
            applied_tag = Items::AppliedTag.find_or_create_by(tag_id: item_tag.id, item_id: item.id)
            applied_tag.save

          rescue => ex 
            puts "Error Saving Items: " + ex.message.to_s
          end

          end
        end
      end
      puts "Completed Item Download"
    end
  end  #end of item_download



 def self.circuitree_download(team = nil, itinerary = nil)
    Team.all.each do |team|
     puts "Begin CT Download for #{team.name}"
     start_date = Date.today
     end_date = Date.today + 50.days

     puts "CTquery method from CT library module"
     url = "https://api.circuitree.com/Exports/ExecuteQuery.json"
   
     paramArray = []

     param = {
      'ParameterID' => 8,
      'ParameterValue' => start_date
        }
     paramArray << param   

     param = {
      'ParameterID' => 9,
      'ParameterValue' => end_date
        } 
     paramArray << param  


     if itinerary.present?
      puts "ItineraryID was present: " + itinerary.to_s
        param = {
      'ParameterID' => 26,
      'ParameterValue' => itinerary
        } 
     paramArray << param 

     end   
     
     data = {
        'ApiToken' => team.circuitree_api,
        'ExportQueryID' =>  team.groups_query,
        'QueryParameters' => paramArray
      }

      uri = URI(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
      req.body = data.to_json
      res = http.request(req)
      ct_results = JSON.parse(res.body)

        puts "Starting Itinerary Download"
        begin
           ct_results.each do |key,value|
            if key == "Results"
              JSON.parse(value).each do |val|
                puts "--------------------~~~~~ " + val['GroupName'] + " ~~~~~---------------------------"
                begin
                 puts "start itinerary search and save"
                 retreat = Retreat.find_or_initialize_by(:team_id => team.id, :id => val['ItineraryID'].to_i)
                 #unless retreat.import_lock == true
                 unless 1 == 2 
                   retreat.name = val['GroupName'].to_s
                   
                   if Rails.env.production?
                    retreat.arrival = DateTime.parse(val['ArrivalDateTime'])
                    retreat.departure = DateTime.parse(val['DepartureDateTime'])
                   else 
                    puts "Development"
                    arrivalDateTime = val['ArrivalDateTime'].to_datetime
                    departureDateTime = val['DepartureDateTime'].to_datetime
                    arrival = Time.now.in_time_zone("Pacific Time (US & Canada)")
                    departure = Time.now.in_time_zone("Pacific Time (US & Canada)")
                    retreat.arrival = arrival.change(:year => arrivalDateTime.year, :month => arrivalDateTime.month, :day => arrivalDateTime.day, :hour => arrivalDateTime.hour, :min => arrivalDateTime.min)
                    retreat.departure = departure.change(:year => departureDateTime.year, :month => departureDateTime.month, :day => departureDateTime.day, :hour => departureDateTime.hour, :min => departureDateTime.min)
                   end 
                   
                   retreat.contract_count = val['ProgramCount'].to_i
                   retreat.id = val['ItineraryID'].to_i
                   retreat.active = val['ItineraryStatus'] == 'Approved' ? true : false


                   ##Save Organization 
                   organization = Organization.find_or_create_by(:team_id => team.id, :name => val['GroupName'].to_s)       
                   organization.name = val['GroupName'].to_s
                   organization.save!
                   retreat.organization_id = organization.id 
                   retreat.save(validate: false) 
                  # retreat.versions.last.update_attributes!(:whodunnit => 1) ##Havent tested

                   puts "Arrival: " + retreat.arrival.strftime("%A %B #{retreat.arrival.day.ordinalize} %-l%P")
                   puts "Departure: " + retreat.departure.strftime("%A %B #{retreat.departure.day.ordinalize}  %-l%P")
                   puts "Guest Contract Count: " + retreat.contract_count.to_s
                   puts "ItineraryStatus: " + retreat.active.to_s
              
                   begin
                     ##Save Contact
                     contact = Organizations::Contact.find_or_create_by(:first_name => val['PrimaryContact'].to_s.split.first, :last_name => val['PrimaryContact'].to_s.split[1..-1].join(' '))
                     contact.save

                     puts "Organization: " + organization.name
                     puts "Organization Contact: " + contact.first_name.to_s + " " + contact.last_name.to_s

                     retreat_contact = Retreats::AssignedContact.find_or_create_by(retreat_id: retreat.id, contact_id: contact.id)
                     retreat_contact.save
                   rescue => ex 
                     puts ex.message
                     puts "Failure to save contact or organization.  This is likely an internal group"
                   end


                   ##Save Host

                   begin
                   puts "Checking User for Host"
                   if val['FHHost'].present?
                     puts "Creating: " + val['FHHost']
                     first = val['FHHost'].to_s.split.first
                     last = val['FHHost'].to_s.split[1..-1].join(' ')
                     user = User.find_or_create_by!(first_name: first, last_name: last) do |u|
                        puts "First Name: " + u.first_name.to_s
                        u.email = first + "." + last + "@foresthome.org"
                        u.password = "fsdfsdjkfdf874r8fh747hffk8l7l"
                        u.time_zone = "Pacific Time (US & Canada)"
                        u.save!
                      end  
 
                    puts "Checking Membership for Host"
                     puts "email: " + first + "." + last + "@foresthome.org"
                      membership = Membership.find_or_create_by(team_id: team.id, user_id: user.id, user_first_name: first, user_last_name: last) do |m|
                        puts "Creating Membership"
                        m.user_email = first + "." + last + "@foresthome.org"
                        m.user_first_name = first
                        m.user_last_name = last 
                        m.save!
                      end
          
                      retreat_host = Retreats::HostTag.find_or_create_by!(retreat_id: retreat.id, host_id: membership.id)
                      retreat_host.save 
                   end
                 rescue => ex 
                  puts "Error Saving Host"
                  puts ex.message
                 end 


                   begin
                    ##Save Event Planner
                   puts "Checking User for Planner"
                   if val['FHEventCoordinator'].present?
                     puts "Creating: " + val['FHEventCoordinator']
                     first = val['FHEventCoordinator'].to_s.split.first
                     last = val['FHEventCoordinator'].to_s.split[1..-1].join(' ')
                     user = User.find_or_create_by!(first_name: first, last_name: last) do |u|
                        puts "First Name: " + u.first_name.to_s
                        u.email = first + "." + last + "@foresthome.org"
                        u.password = "fsdfsdjkfdf874r8fh747hffk8l7l"
                        u.time_zone = "Pacific Time (US & Canada)"
                        u.save!
                      end  
 
                  puts "Checking Membership for Planner"

                   membership = Membership.find_or_initialize_by(team_id: team.id, user_id: user.id) do |new_membership|
                      puts "Creating Membership"
                      new_membership.user_email = "#{first}.#{last}@foresthome.org"
                      new_membership.user_first_name = first
                      new_membership.user_last_name = last
                    end

                    membership.save!


                      retreat_planner = Retreats::PlannerTag.find_or_create_by!(retreat_id: retreat.id, planner_id: membership.id)
                      retreat_planner.save 
                   end
                 rescue => ex 
                  puts "Error saving Event Planner.."
                  puts ex.message 
                 end 


                   ##Save Location
                    location = Location.find_or_create_by(:team_id => team.id, :name => val['Location'].to_s) do |l|
                      l.initials = val['Location'].to_s[0, 2].upcase
                      l.save
                    end

                    retreat_location = Retreats::LocationTag.find_or_create_by(retreat_id: retreat.id, location_id: location.id)
                    retreat_location.save!
                    puts "Location: " + retreat_location.location.name

                  ##Save Demographic

                  if val['Internal'] == "TRUE" || val['GroupName'] == 'FH Ministry Partner'
                    puts "INTERNAL Group"
                    internal = Demographic.find_or_create_by!(:team_id => team.id, :name => "Internal") do |d|
                        d.save 
                    end    
                    retreat_demographic = Retreats::DemographicTag.find_or_create_by(retreat_id: retreat.id, demographic_id: internal.id)
                    retreat_demographic.save
                    retreat.internal = true
                    retreat.save
                  end

                  if val['GroupType'].present?
                      demographic = Demographic.find_or_create_by!(:team_id => team.id, :name => val['GroupType'].to_s) do |d|
                        d.save 
                      end 

                      puts "Demographic: " + demographic.name

                      retreat_demographic = Retreats::DemographicTag.find_or_create_by(retreat_id: retreat.id, demographic_id: demographic.id)
                      retreat_demographic.save


                      exclusive = Demographic.find_or_create_by!(:team_id => team.id, :name => val['UseBasis'].to_s) do |e|
                        e.save 
                      end 

                      puts "Exclusive: " + exclusive.name

                      retreat_demographic = Retreats::DemographicTag.find_or_create_by(retreat_id: retreat.id, demographic_id: exclusive.id)
                      retreat_demographic.save


                  end
                  end
                  #Download Retreat Reservations
                  res = Reservations_download(retreat.id)
                 puts "Successful Itinerary Download" 
                 
                rescue => ex
                  puts "Not a successful Itinerary Download"
                  puts ex.message
                end   
              end   ##JSON.parse 
            end  ##if Key
          end ## ct_results  
        rescue => ex
          puts ex.message
        end 
      puts "Completed Itinerary Download"
    

      puts "Success"
  end 
 end #Group Download 

 def self.program_download(team = nil, year = nil)
    Team.all.each do |team|
     puts "Begin Program Event Download for #{team.name}"
     puts "CTquery method from CT library module"
     url = "https://api.circuitree.com/Exports/ExecuteQuery.json"
   
     paramArray = []

     param = {
      'ParameterID' => 7,
      'ParameterValue' => Date.today.year
        }
     paramArray << param     
     
     data = {
        'ApiToken' => team.circuitree_api,
        'ExportQueryID' =>  team.programs_query,
        'QueryParameters' => paramArray
      }

      uri = URI(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
      req.body = data.to_json
      res = http.request(req)
      ct_results = JSON.parse(res.body)

        puts "Starting Program Download"
          begin
            ct_results.each do |key, value|
              next unless key == "Results"

              JSON.parse(value).each do |val|
                puts "--------------------~~~~~ #{val['EventName']} ~~~~~---------------------------"
                begin
                  puts "Start Event search and save"
                  retreat = Retreat.find_by(id: val['EventID'].to_i)

                  if retreat
                    puts "Updating existing retreat: #{retreat.id}"
                    retreat.update!(
                      name: val['EventName'],
                      arrival: DateTime.parse(val['ArrivalDateTime']),
                      departure: DateTime.parse(val['DepartureDateTime']),
                      contract_count: val['GuestCount'].to_i,
                      program_event: true
                    )
                  else
                    puts "Creating new retreat."
                    Retreat.create!(
                      id: val['EventID'].to_i,
                      team_id: team.id,
                      name: val['EventName'],
                      arrival: DateTime.parse(val['ArrivalDateTime']),
                      departure: DateTime.parse(val['DepartureDateTime']),
                      contract_count: val['GuestCount'].to_i,
                      program_event: true
                    )
                  end

                  # Save Location
                  location = Location.find_or_create_by(team_id: team.id, name: val['Location']) do |l|
                    l.initials = val['Location'][0, 2].upcase
                  end
                  retreat_location = Retreats::LocationTag.find_or_create_by(retreat_id: retreat.id, location_id: location.id)
                  retreat_location.save!


                    internal = Demographic.find_or_create_by!(:team_id => team.id, :name => "Program Event") do |d|
                        d.save 
                    end    
                    retreat_demographic = Retreats::DemographicTag.find_or_create_by(retreat_id: retreat.id, demographic_id: internal.id)
                    retreat_demographic.save

                    event_type = Demographic.find_or_create_by!(:team_id => team.id, :name => val['EventType']) do |d|
                        d.save 
                    end    
                    retreat_demographic = Retreats::DemographicTag.find_or_create_by(retreat_id: retreat.id, demographic_id: event_type.id)
                    retreat_demographic.save

                  


                  puts "Location: #{retreat_location.location.name}"
                  puts "Successful with #{retreat.name} it is an #{retreat.internal} retreat with id #{retreat.id}"
                rescue => ex
                  puts "Not a successful Program Download"
                  puts ex.message
                end
              end
            end
          rescue => ex
            puts ex.message
          end
          puts "Successfully completed Program Events Download"


      end  

 end #Program Events Download 


 def self.Reservations_download(itinerary)
        current_team = Team.first
      begin
      
        puts "CTquery method from CT library module"
        @Url = "https://api.circuitree.com/Exports/ExecuteQuery.json"
        @ApiToken = "C-rfuf3c/DjFYjAAEkPVqRAdxrxFBvFOmNRicxLQDBoZPUgZ6XJokrsEuW1knO0M9xRmacxonJ//nBffDCe4HiIQTomnKu1vBO"

       #puts "CT Query is: 484"

     @team = Team.first 
   
     paramArray = []
     

     
       param = {
      'ParameterID' => 26,
      'ParameterValue' => itinerary
        }
        paramArray << param
       

      data = {
        'ApiToken' => @ApiToken,
        'ExportQueryID' => 484,
        'QueryParameters' => paramArray
      }

      uri = URI(@Url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json')
      req.body = data.to_json
      res = http.request(req)
      @ct_results2 = JSON.parse(res.body)

    
      rescue => ex
        puts ex.message
        puts "--------------- ERROR --------- ERROR ----------------  ERROR ---------------"
        
    end
     
      begin
       @ct_results2.each do |key,value|
        if key == "Results"
          JSON.parse(value).each do |val|
            reservation_count = Reservation.where(id: val['ReservationItemID'].to_i).count
            if reservation_count == 0
              begin
                puts "************************************************"
                puts "Reservation Info"
                #puts val
                puts "Name: " + val['Name'].to_s
                puts "ReservationID: " + val['ReservationItemID'].to_s
                puts "ResourceID: " + val['ResourceID'].to_s
                puts "ItineraryID: " + val['ItineraryID'].to_s
                puts "Name: " + val['Name'].to_s
                puts "ReservationStatus: " + val['ReservationStatusName'].to_s
                puts "************************************************"

                reservation = Reservation.find_or_create_by(:team_id => 1, :retreat_id => val['ItineraryID'].to_s, :item_id => val['ResourceID'].to_s)
                 PaperTrail.request.whodunnit = 'Circuitree'
                 arrivalDateTime = val['StartDateTime'].to_datetime
                 departureDateTime = val['EndDateTime'].to_datetime
                 start_time = Time.now
                 end_time = Time.now 
                 reservation.start_time = start_time.change(:year => arrivalDateTime.year, :month => arrivalDateTime.month, :day => arrivalDateTime.day, :hour => arrivalDateTime.hour, :min => arrivalDateTime.min)
                 reservation.end_time = end_time.change(:year => departureDateTime.year, :month => departureDateTime.month, :day => departureDateTime.day, :hour => departureDateTime.hour, :min => departureDateTime.min)
                 reservation.name = val['Name'].to_s

                 unless reservation.notes.present?
                   ##reservation.notes = val['comments'].to_s
                 end  


                 reservation.active = val['ReservationStatusName'] == 'Active' ? true : false
                 reservation.item_id = val['ResourceID'].to_s
                 reservation.retreat_id = val['ItineraryID'].to_s
                 reservation.quantity = val['Quantity'].to_s
   
                if reservation.save(validate: false) 
                  puts reservation.name + ": save successful"
                else
                  puts "There were errors: "
                  puts reservation.errors
                end
              rescue => ex
                puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                puts "FAILED TO SAVE RESERVATION"
                puts "Name: " + val['Name'].to_s
                puts "ReservationID: " + val['ReservationItemID'].to_s
                puts "ResourceID: " + val['ResourceID'].to_s
                puts "ItineraryID: " + val['ItineraryID'].to_s
                puts "Name: " + val['Name'].to_s
                puts "ReservationStatus: " + val['ReservationStatusName'].to_s
                puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
                puts ex.message
              end

            else
              #Not going to do anything if already exists
            end 
          end
        end
      end
       puts "Successful Reservation Download"
    rescue => ex
      
       puts ex.message
       puts "Error in Reservation Download"
    end
  end

def self.set_internal
    Retreat.find_each do |retreat|
    # Check if the retreat has a tag named "internal"
    if retreat.demographics.exists?(name: 'Internal')
      puts "Processing Retreat ##{retreat.id}: Internal Group"

      # Find or create the team associated with the retreat
      team = retreat.team
      next unless team  # Skip if the retreat does not have a team

      # Find or create the "Internal" demographic for the team
      internal = Demographic.find_or_create_by!(team_id: team.id, name: 'Internal')

      # Tag the retreat with the "Internal" demographic
      retreat_demographic = Retreats::DemographicTag.find_or_create_by(
        retreat_id: retreat.id,
        demographic_id: internal.id
      )

      # Set the `internal` flag to true and save the retreat
      retreat.internal = true
      if retreat.save
        puts "Updated Retreat ##{retreat.id} as Internal."
      else
        puts "Failed to update Retreat ##{retreat.id}: #{retreat.errors.full_messages.join(', ')}"
      end
    else
      puts "Retreat ##{retreat.id} does not have the 'internal' tag."
    end
  end
end

def self.create_item_abbreviations
  Item.all.each do |item|
    if item.abbreviation.blank?
      item.update(abbreviation: item.name.to_s[0, 5]) # Take the first 5 characters of the name
    end
  end
end










   end 

  
 end