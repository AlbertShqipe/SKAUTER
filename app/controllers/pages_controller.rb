class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @counties = County
      .left_joins(:locations)
      .where(locations: { available: true })
      .group("counties.id")
      .select(
        "counties.*,
        COUNT(locations.id) AS locations_count"
      )
  end
end
