class Team < ApplicationRecord
    has_many :team_assets, dependent: :destroy
end
