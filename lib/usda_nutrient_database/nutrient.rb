module UsdaNutrientDatabase
  class Nutrient < ActiveRecord::Base
    self.table_name = 'usda_nutrients'
    self.primary_key = 'nutrient_number'

    validates :nutrient_number, presence: true,
      uniqueness: { allow_blank: true }
    validates :units, presence: true
    validates :nutrient_description, presence: true
    validates :number_decimal_places, presence: true
    validates :sort_record_order, presence: true,
      numericality: { allow_blank: true }

    has_many :foods_nutrients,
      class_name: 'UsdaNutrientDatabase::FoodsNutrient',
      dependent: :destroy

    has_many :footnotes, class_name: 'UsdaNutrientDatabase::Footnote'
  end
end
