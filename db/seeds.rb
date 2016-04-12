# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(email: 'admin@rosewoodresidence.com', password: 'secret123')

Setting.create(
email: 'inquiries@rosewoodresidence.com',
address: 'Gov M Cuenco Avenue, Cebu City',
page_description: 'To check for room availability, schedule a room inspection or for other inquiries, please fill in the form and we will get back to you as soon as we can!',
about_us: 'Rosewood Residence is committed to providing customers, particularly students, with an environment suitable for nurturing their growth and achievement. All our rooms are built and designed with the needs of a student in mind. Each room is proviided with ample cabinet and table space. Provisions for natural light to enter are installed across all rooms. Despite being fully airconditioned, residents may opt for fresh air as ventilation in between rooms is has been made top priority. With our comfortable rooms and convenient location, students now have the convenience of going back to their rooms in between classes.',
why_us_1: 'Free wi-fi is a main consideration for students choosing accomodations. We have provided free wi-fi for all residents at no additonal cost, so you do not need to  go through the trouble of applying for a connection yourself',
why_us_2: 'All rooms are provided with private ensuite bathrooms so you do not have to go down the hall to take a bath or to use the toilet.',
why_us_3: 'Privacy and security are our top priorities. Only registered residents are allowed inside Rosewood Residence premises. In addition to that, 24-7 security and cctv systems are installed at all public areas.'
)


Faq.create(question: 'Are rooms equipped with a telephone line?', answer: 'Sorry, rooms are not equipped with a fixed telephone line. However, we have a pay phone at the lobby. However, most of our residents prefer using their for their communication needs.')
Faq.create(question: 'Are rooms furnished?', answer: 'All rooms are provided with beds and mattresses. Ample cabinet and table space is also installed.')
Faq.create(question: 'Are rooms equipped with air conditioners?', answer: 'Yes, each room is equipped with an air conditioner.')
Faq.create(question: 'What kind of documents do I need to sign a lease agreement?', answer: 'For local residents, we will a government id aside from your current school id. For foreign students, we will require your passport and your current school id.')
Faq.create(question: 'How long is the minimum rental term?', answer: 'Minimum lease term is one semester. That would be June to October, November to March or April to May.')
Faq.create(question: 'Can I arrange for a room viewing?', answer: 'Sure, please contact us so we can set a schedule for inspection.')
Faq.create(question: 'What else do I have to pay?', answer: 'We will require a deposit of one month. This will be refunded if the room is left free of damages. else actual cost of repairs will be taken from the deposit. Aside from the monthly rental, electricity and water consumption will also be charged.')
Faq.create(question: 'Are meals included in the rent?', answer: 'No, unfortunately meals are not included as of this time.')
Faq.create(question: 'Will I be allowed to share the room with a friend or family member who will be in town for a few days?')
Faq.create(question: 'Is there a building curfew?')
Faq.create(question: 'Can I smoke in the room?', answer: 'Smoking is prohibited in the rooms, bathroom, and all areas of the building. Smoking in outside the building is also not allowed as Cebu City has an anti-smoking ordinance in place.')
Faq.create(question: 'Do I need to inform Rosewood Residence before I move out?', answer: 'If you wish to move out, we require at least 1 month advance notice. Notice must be given by completing out "Move Out Request Form and submitting it to our office.')
Faq.create(question: 'How soon do I need to inform  Rosewood Residence that I plan to move out?', answer: 'A minimum of 1 month advance notice is required if you wish to move out. Please be informed that if the 1 month advance notice is not given, a 1 month rent will still be charged from the day that we are informed.')
Faq.create(question: 'When is the monthly cut off date?', answer: '')
Faq.create(question: 'Can I ask for an extra bed?', answer: 'Our rooms are specifically made for those who want more comfort and convenience. If the number of persons in your group exceed the room limit, we will be happy provide you with more rooms.')

Room.create(room_no: 201, max_occupants: 3, room_rate: 10000, active: true)
Room.create(room_no: 202, max_occupants: 3, room_rate: 9000, active: true)
Room.create(room_no: 203, max_occupants: 3, room_rate: 9000, active: true)
Room.create(room_no: 204, max_occupants: 2, room_rate: 8000, active: true)
Room.create(room_no: 205, max_occupants: 2, room_rate: 8000, active: true)

Occupant.create(first_name: 'John', last_name: 'Smith')
Occupant.create(first_name: 'Jane', last_name: 'Doe')