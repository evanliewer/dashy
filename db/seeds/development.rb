puts "🌱 Generating development environment seeds."


Department.find_or_create_by(name: 'Recreation', dashboard: true)
Department.find_or_create_by(name: 'Guest Dining', dashboard: true)
Department.find_or_create_by(name: 'Accommodations', dashboard: true)
Department.find_or_create_by(name: 'Buildings and Grounds', dashboard: true)
Department.find_or_create_by(name: 'Audio Visual', dashboard: true)

