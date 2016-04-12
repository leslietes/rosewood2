class CreateOccupants < ActiveRecord::Migration
  def change
    create_table :occupants do |t|
      t.string  :first_name 
      t.string  :last_name  
      t.string  :address1   
      t.string  :address2
      t.string  :city
      t.string  :province
      t.string  :postcode
      t.string  :telephone
      t.string  :mobile
      t.date    :birthdate
      
      t.string  :school_or_work
      t.string  :course_or_position
      t.string  :year_or_date_started
      
      t.string  :previous_school_or_work
      t.string  :school_city
      t.string  :school_province
      t.string  :course_and_year
      t.string  :work_position
      t.string  :date_left
      
      t.string  :fathers_name
      t.string  :fathers_address
      t.string  :fathers_occupation
      t.string  :fathers_company
      t.string  :fathers_company_address
      t.string  :fathers_telephone
      t.string  :fathers_mobile
      
      t.string  :mothers_name
      t.string  :mothers_address
      t.string  :mothers_occupation
      t.string  :mothers_company
      t.string  :mothers_company_address
      t.string  :mothers_telephone
      t.string  :mothers_mobile
      
      t.string  :guardians_name
      t.string  :guardians_address
      t.string  :guardians_telephone
      t.string  :guardians_mobile
      
      t.boolean :waiting, null: false, default: true
      t.boolean :active,  null: false, default: true
      
      t.timestamps null: false
    end
  end
end
