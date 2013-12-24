require 'csv'

module UsdaNutrientDatabase
  module Import
    class FoodGroups < UsdaNutrientDatabase::Import::Base
      def import
        CSV.open("#{directory}/FD_GROUP.txt", 'r', csv_options) do |csv|
          csv.each do |row|
            UsdaNutrientDatabase::FoodGroup.create! code: row[0],
              description: row[1]
          end
        end
      end
    end
  end
end
