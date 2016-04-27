# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(email: 'admin@example.com',  password: 'secret123', admin: true,  name: 'admin',  active: true)
User.create(email: 'leslie@example.com', password: 'secret123', admin: false, name: 'leslie', active: true)

Setting.create(
email: 'inquiries@rosewoodresidence.com',
address: 'Gov M Cuenco Avenue, Cebu City',
page_description: 'To check for room availability, schedule a room inspection or for other inquiries, please fill in the form and we will get back to you as soon as we can!',
about_us: 'Rosewood Residence is committed to providing customers, particularly students, with an environment suitable for nurturing their growth and achievement. All our rooms are built and designed with the needs of a student in mind. Each room is proviided with ample cabinet and table space. Provisions for natural light to enter are installed across all rooms. Despite being fully airconditioned, residents may opt for fresh air as ventilation in between rooms is has been made top priority. With our comfortable rooms and convenient location, students now have the convenience of going back to their rooms in between classes.',
why_us_1: 'Free wi-fi is a main consideration for students choosing accomodations. We have provided free wi-fi for all residents at no additonal cost, so you do not need to  go through the trouble of applying for a connection yourself',
why_us_2: 'All rooms are provided with private ensuite bathrooms so you do not have to go down the hall to take a bath or to use the toilet.',
why_us_3: 'Privacy and security are our top priorities. Only registered residents are allowed inside Rosewood Residence premises. In addition to that, 24-7 security and cctv systems are installed at all public areas.',
user_id:  1
)


Faq.create(question: 'Are rooms equipped with a telephone line?', answer: 'Sorry, rooms are not equipped with a fixed telephone line. However, we have a pay phone at the lobby. However, most of our residents prefer using their for their communication needs.', user_id: 1)
Faq.create(question: 'Are rooms furnished?', answer: 'All rooms are provided with beds and mattresses. Ample cabinet and table space is also installed.', user_id: 1)
Faq.create(question: 'Are rooms equipped with air conditioners?', answer: 'Yes, each room is equipped with an air conditioner.', user_id: 1)
Faq.create(question: 'What kind of documents do I need to sign a lease agreement?', answer: 'For local residents, we will a government id aside from your current school id. For foreign students, we will require your passport and your current school id.', user_id: 1)
Faq.create(question: 'How long is the minimum rental term?', answer: 'Minimum lease term is one semester. That would be June to October, November to March or April to May.', user_id: 1)
Faq.create(question: 'Can I arrange for a room viewing?', answer: 'Sure, please contact us so we can set a schedule for inspection.', user_id: 1)
Faq.create(question: 'What else do I have to pay?', answer: 'We will require a deposit of one month. This will be refunded if the room is left free of damages. else actual cost of repairs will be taken from the deposit. Aside from the monthly rental, electricity and water consumption will also be charged.', user_id: 1)
Faq.create(question: 'Are meals included in the rent?', answer: 'No, unfortunately meals are not included as of this time.', user_id: 1)
Faq.create(question: 'Will I be allowed to share the room with a friend or family member who will be in town for a few days?', user_id: 1)
Faq.create(question: 'Is there a building curfew?', user_id: 1)
Faq.create(question: 'Can I smoke in the room?', answer: 'Smoking is prohibited in the rooms, bathroom, and all areas of the building. Smoking in outside the building is also not allowed as Cebu City has an anti-smoking ordinance in place.', user_id: 1)
Faq.create(question: 'Do I need to inform Rosewood Residence before I move out?', answer: 'If you wish to move out, we require at least 1 month advance notice. Notice must be given by completing out "Move Out Request Form and submitting it to our office.', user_id: 1)
Faq.create(question: 'How soon do I need to inform  Rosewood Residence that I plan to move out?', answer: 'A minimum of 1 month advance notice is required if you wish to move out. Please be informed that if the 1 month advance notice is not given, a 1 month rent will still be charged from the day that we are informed.', user_id: 1)
Faq.create(question: 'When is the monthly cut off date?', answer: '', user_id: 1)
Faq.create(question: 'Can I ask for an extra bed?', answer: 'Our rooms are specifically made for those who want more comfort and convenience. If the number of persons in your group exceed the room limit, we will be happy provide you with more rooms.', user_id: 1)


Room.create(room_no: 101, max_occupants: 2, room_rate: 8000, active: false, user_id: 1)
Room.create(room_no: 102, max_occupants: 4, room_rate: 12000, active: true, user_id: 1)

Room.create(room_no: 201, max_occupants: 3, room_rate: 10500, active: true, user_id: 1)
Room.create(room_no: 202, max_occupants: 3, room_rate: 10000, active: true, user_id: 1)
Room.create(room_no: 203, max_occupants: 3, room_rate: 9000, active: true,  user_id: 1)
Room.create(room_no: 204, max_occupants: 2, room_rate: 8500, active: true,  user_id: 1)
Room.create(room_no: 205, max_occupants: 2, room_rate: 8000, active: true,  user_id: 1)
Room.create(room_no: 206, max_occupants: 2, room_rate: 8000, active: true,  user_id: 1)
Room.create(room_no: 207, max_occupants: 2, room_rate: 7500, active: true,  user_id: 1)
Room.create(room_no: 208, max_occupants: 2, room_rate: 7500, active: true,  user_id: 1)
Room.create(room_no: 209, max_occupants: 2, room_rate: 7500, active: true,  user_id: 1)
Room.create(room_no: 210, max_occupants: 2, room_rate: 7500, active: true,  user_id: 1)
Room.create(room_no: 211, max_occupants: 2, room_rate: 8000, active: true,  user_id: 1)
Room.create(room_no: 212, max_occupants: 3, room_rate: 11500, active: true, user_id: 1)

Room.create(room_no: 301, max_occupants: 3, room_rate: 10500, active: true, user_id: 1)
Room.create(room_no: 302, max_occupants: 3, room_rate: 10000, active: true, user_id: 1)
Room.create(room_no: 303, max_occupants: 3, room_rate: 9000, active: true,  user_id: 1)
Room.create(room_no: 304, max_occupants: 2, room_rate: 8500, active: true,  user_id: 1)
Room.create(room_no: 305, max_occupants: 2, room_rate: 8000, active: true,  user_id: 1)
Room.create(room_no: 306, max_occupants: 2, room_rate: 8000, active: true,  user_id: 1)
Room.create(room_no: 307, max_occupants: 2, room_rate: 7500, active: true,  user_id: 1)
Room.create(room_no: 308, max_occupants: 2, room_rate: 7500, active: true,  user_id: 1)
Room.create(room_no: 309, max_occupants: 2, room_rate: 7500, active: true,  user_id: 1)
Room.create(room_no: 310, max_occupants: 2, room_rate: 7500, active: true,  user_id: 1)
Room.create(room_no: 311, max_occupants: 2, room_rate: 8000, active: true,  user_id: 1)
Room.create(room_no: 312, max_occupants: 3, room_rate: 11500, active: true, user_id: 1)

Room.create(room_no: 401, max_occupants: 3, room_rate: 10000, active: true, user_id: 1)
Room.create(room_no: 402, max_occupants: 3, room_rate: 9500, active: true,  user_id: 1)
Room.create(room_no: 403, max_occupants: 3, room_rate: 8500, active: true,  user_id: 1)
Room.create(room_no: 404, max_occupants: 2, room_rate: 8000, active: true,  user_id: 1)
Room.create(room_no: 405, max_occupants: 2, room_rate: 7500, active: true,  user_id: 1)
Room.create(room_no: 406, max_occupants: 2, room_rate: 7500, active: true,  user_id: 1)
Room.create(room_no: 407, max_occupants: 2, room_rate: 7000, active: true,  user_id: 1)
Room.create(room_no: 408, max_occupants: 2, room_rate: 7000, active: true,  user_id: 1)
Room.create(room_no: 409, max_occupants: 2, room_rate: 7000, active: true,  user_id: 1)
Room.create(room_no: 410, max_occupants: 2, room_rate: 7000, active: true,  user_id: 1)
Room.create(room_no: 411, max_occupants: 2, room_rate: 75000, active: true, user_id: 1)
Room.create(room_no: 412, max_occupants: 3, room_rate: 11000, active: true, user_id: 1)

Utility.create(name: 'Room Rate',             category: 'Basic', user_id: 1)
Utility.create(name: 'Electricity',           category: 'Basic', description: "Monthly. Per kilowatt hour",    first_limit: 0, first_rate: 11, excess_rate: 0, unit: 'per kwh', user_id: 1)
Utility.create(name: 'Water',                 category: 'Basic', description: "Monthly. First 10 cubic meter", first_limit: 10,first_rate: 150, excess_rate: 20, unit: 'per cubic meter', user_id: 1)
Utility.create(name: 'Cable TV Subscription', category: 'Bxtra', description: "Monthly fee",  first_rate: 450, unit: 'per month', user_id: 1)
Utility.create(name: 'Cable TV Installation', category: 'Bxtra', description: "One time fee", first_rate: 450, unit: 'one time',  user_id: 1)
Utility.create(name: 'Cable TV Termination',  category: 'Bxtra', description: "One time fee", first_rate: 450, unit: 'one time',  user_id: 1)

Utility.create(name: 'Parking Fee',    category: 'Extra', description: "Monthly parking fee",    first_rate: 2000,       unit: 'per month', user_id: 1)
Utility.create(name: 'Transcient Fee', category: 'Extra', description: "Extra person per night", first_rate: 250,        unit: 'per night', user_id: 1)
Utility.create(name: 'Penalty',        category: 'Extra', description: "Past due penalty",       first_rate: 100,        unit: 'per day',   user_id: 1)
Utility.create(name: 'Damages',        category: 'Extra', description: "Rate depending on damage",                       unit: 'per damage',user_id: 1)
Utility.create(name: 'Cleaning Fee',   category: 'Extra', description: "Out-of-cycle cleaning request", first_rate: 350, unit: 'per room',  user_id: 1)

Occupant.create(first_name: 'Racquel', last_name: 'Tecson',    user_id: 1)
Occupant.create(first_name: 'A',       last_name: 'Autentico', user_id: 1)
Occupant.create(first_name: 'M',       last_name: 'Autentico', user_id: 1)
Occupant.create(first_name: 'K',       last_name: 'Turan',     user_id: 1)
Occupant.create(first_name: 'Kimberly', last_name: 'Acorin',   user_id: 1)
Occupant.create(first_name: 'Mellany',  last_name: 'Yap',      user_id: 1)
Occupant.create(first_name: 'Allyssa',  last_name: 'Tugung',   user_id: 1)
Occupant.create(first_name: 'Cara',     last_name: 'Ambowang', user_id: 1)
Occupant.create(first_name: 'Wilvera',  last_name: 'Malaque',  user_id: 1)
Occupant.create(first_name: 'S',        last_name: 'Yee',      user_id: 1)
Occupant.create(first_name: 'C',        last_name: 'Delmonte', user_id: 1)
Occupant.create(first_name: 'A',        last_name: 'Ranin',    user_id: 1)
Occupant.create(first_name: 'C',        last_name: 'Ranin',    user_id: 1)
Occupant.create(first_name: 'Hannah Marie', last_name: 'Godin',user_id: 1)
Occupant.create(first_name: 'Bea',          last_name: 'Sojor',user_id: 1)
Occupant.create(first_name: 'Jana',         last_name: 'Aala', user_id: 1)
Occupant.create(first_name: 'Nolanda',      last_name: 'Del Mundo', user_id: 1)
Occupant.create(first_name: 'Jean Leanne',  last_name: 'Hong', user_id: 1)
Occupant.create(first_name: 'Gabrielle',    last_name: 'Velasquez', user_id: 1)
Occupant.create(first_name: 'G',            last_name: 'Velasquez', user_id: 1)
Occupant.create(first_name: 'D',            last_name: 'Longos', user_id: 1)
Occupant.create(first_name: 'N',            last_name: 'Angob',  user_id: 1)
Occupant.create(first_name: 'M',            last_name: 'Ronulo', user_id: 1)
Occupant.create(first_name: 'A',            last_name: 'Canizares', user_id: 1)
Occupant.create(first_name: 'B',            last_name: 'Canizares', user_id: 1)
Occupant.create(first_name: 'Micah',        last_name: 'Bolivar',   user_id: 1)
Occupant.create(first_name: 'R',            last_name: 'Chato',     user_id: 1)
Occupant.create(first_name: 'A',            last_name: 'Balo',      user_id: 1)
Occupant.create(first_name: 'A',            last_name: 'Balo',      user_id: 1)
Occupant.create(first_name: 'J',            last_name: 'Nudalo',    user_id: 1)
Occupant.create(first_name: 'J',            last_name: 'Nudalo',    user_id: 1)
Occupant.create(first_name: 'Marjorie',     last_name: 'Secretaria',user_id: 1)
Occupant.create(first_name: 'P',            last_name: 'Deada',     user_id: 1)
Occupant.create(first_name: 'A',            last_name: 'Sosobrado', user_id: 1)
Occupant.create(first_name: 'Yumiko',       last_name: 'Legaspi',   user_id: 1)
Occupant.create(first_name: 'S',            last_name: 'Galvez',    user_id: 1)
Occupant.create(first_name: 'M',            last_name: 'Betonio',   user_id: 1)
Occupant.create(first_name: 'Judea',        last_name: 'Plaza',     user_id: 1)
Occupant.create(first_name: 'Yerha',        last_name: 'Silawan',   user_id: 1)