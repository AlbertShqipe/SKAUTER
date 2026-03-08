class SiteSetting < ApplicationRecord
  def self.enabled?(key)
    find_by(key: key)&.value == true
  end
end
