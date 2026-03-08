SiteSetting.find_or_create_by(key: "show_classic_booking").tap do |s|
  s.update(value: false) # default: show general booking
end
