counties = [
  "Berat",
  "Dibër",
  "Durrës",
  "Elbasan",
  "Fier",
  "Gjirokastër",
  "Korçë",
  "Kukës",
  "Lezhë",
  "Shkodër",
  "Tirana",
  "Vlorë"
]

counties.each do |name|
  County.find_or_create_by!(name: name) do |county|
    county.slug = name.parameterize
    county.description = "#{name} county offers unique cinematic locations across Albania."
  end
end

puts "✅ #{County.count} counties created"
