class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|

      t.string :address
      t.string :phone
      t.string :mobile
      t.string :email
      t.text   :page_description

      t.string :home_section_header_1
      t.string :home_section_header_2
      t.string :home_section_header_3

      t.text   :home_section_1
      t.text   :home_section_2
      t.text   :home_section_3

      t.string  :photo1_file_name
      t.string  :photo1_content_type
      t.integer :photo1_file_size

      t.string  :photo2_file_name
      t.string  :photo2_content_type
      t.integer :photo2_file_size

      t.string  :photo3_file_name
      t.string  :photo3_content_type
      t.integer :photo3_file_size

      t.string  :photo4_file_name
      t.string  :photo4_content_type
      t.integer :photo4_file_size

      t.string  :photo5_file_name
      t.string  :photo5_content_type
      t.integer :photo5_file_size

      t.string  :photo1_caption
      t.string  :photo2_caption
      t.string  :photo3_caption
      t.string  :photo4_caption
      t.string  :photo5_caption
      
      t.text    :about_us
      
      t.text    :why_us_1
      t.text    :why_us_2
      t.text    :why_us_3
      
      t.string  :whyus1_file_name
      t.string  :whyus1_content_type
      t.integer :whyus1_file_size

      t.string  :whyus2_file_name
      t.string  :whyus2_content_type
      t.integer :whyus2_file_size

      t.string  :whyus3_file_name
      t.string  :whyus3_content_type
      t.integer :whyus3_file_size

      t.timestamps null: false
    end
  end
end
