drop database if exists TravelManagement;
create database TravelManagement;
use TravelManagement;

-- Create USER Table
CREATE TABLE User (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    Username VARCHAR(100) NOT NULL UNIQUE,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Nationality VARCHAR(100) NOT NULL,
    DateJoined TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create AIRLINE Table
CREATE TABLE Airline (
    AirlineID INT AUTO_INCREMENT PRIMARY KEY,
    AirlineName VARCHAR(100) NOT NULL,
    AirlineCode VARCHAR(10) NOT NULL UNIQUE,
    Country VARCHAR(100) NOT NULL
);

-- Create AIRPORT Table
CREATE TABLE Airport (
    AirportID INT AUTO_INCREMENT PRIMARY KEY,
    AirportName VARCHAR(100) NOT NULL,
    City VARCHAR(100) NOT NULL,
    Country VARCHAR(100) NOT NULL,
    AirportCode VARCHAR(10) NOT NULL UNIQUE
);

-- Create FLIGHT Table
CREATE TABLE Flight (
    FlightID INT AUTO_INCREMENT PRIMARY KEY,
    FlightNumber VARCHAR(10) NOT NULL,
    DepartureTime DATETIME NOT NULL,
    ArrivalTime DATETIME NOT NULL,
    Price DECIMAL(10, 2) NOT NULL CHECK (Price >= 0),
    AirlineID INT NOT NULL,
    DepartureAirportID INT NOT NULL,
    ArrivalAirportID INT NOT NULL,
    FOREIGN KEY (AirlineID) REFERENCES Airline(AirlineID),
    FOREIGN KEY (DepartureAirportID) REFERENCES Airport(AirportID),
    FOREIGN KEY (ArrivalAirportID) REFERENCES Airport(AirportID),
    UNIQUE (FlightNumber, DepartureTime)
);

-- Create REGION Table
CREATE TABLE Region (
    RegionID INT AUTO_INCREMENT PRIMARY KEY,
    RegionName VARCHAR(100) NOT NULL UNIQUE,
    RegionDescription TEXT NOT NULL
);

-- Create ATTRACTION Table
CREATE TABLE Attraction (
    AttractionID INT AUTO_INCREMENT PRIMARY KEY,
    AttractionName VARCHAR(100) NOT NULL,
    AttractionDescription TEXT NOT NULL,
    Rating DECIMAL(3, 2) NOT NULL CHECK (Rating BETWEEN 0 AND 5),
    RegionID INT NOT NULL,
    AttractionType VARCHAR(50) NOT NULL, -- New attribute to distinguish types of attractions
    EntryFee DECIMAL(10,2),
    FOREIGN KEY (RegionID) REFERENCES Region(RegionID) ON DELETE CASCADE
);

-- Add specific table for Nightclub details
CREATE TABLE Nightclub (
    AttractionID INT PRIMARY KEY,
    MusicType VARCHAR(100) NOT NULL,
    Location VARCHAR(100) NOT NULL,
    OpeningHours VARCHAR(50) NOT NULL,
    FOREIGN KEY (AttractionID) REFERENCES Attraction(AttractionID)
);

-- Create RESTAURANT Table
CREATE TABLE Restaurant (
    RestaurantID INT AUTO_INCREMENT PRIMARY KEY,
    RestaurantName VARCHAR(100) NOT NULL,
    Cuisine VARCHAR(100) NOT NULL,
    PriceRange VARCHAR(50) NOT NULL,
    OpeningHours VARCHAR(50) NOT NULL,
    RegionID INT NOT NULL,
    FOREIGN KEY (RegionID) REFERENCES Region(RegionID),
    UNIQUE (RestaurantName, RegionID)
);

-- Create BOOKING Table
CREATE TABLE Booking (
    BookingID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT NOT NULL,
    BookingDate DATE NOT NULL,
    TotalCost DECIMAL(10, 2) NOT NULL CHECK (TotalCost >= 0),
    FlightID INT,
    RestaurantID INT,
    AttractionID INT,
    FOREIGN KEY (UserID) REFERENCES User(UserID),
    FOREIGN KEY (FlightID) REFERENCES Flight(FlightID),
    FOREIGN KEY (RestaurantID) REFERENCES Restaurant(RestaurantID),
    FOREIGN KEY (AttractionID) REFERENCES Attraction(AttractionID)
);

-- Create REVIEW Table
CREATE TABLE Review (
    ReviewID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT NOT NULL,
    ReviewDate DATE NOT NULL,
    ReviewComment TEXT NOT NULL,
    Rating DECIMAL(3, 2) NOT NULL CHECK (Rating BETWEEN 0 AND 5),
    RestaurantID INT,
    AttractionID INT,
    EntityType ENUM('Restaurant', 'Attraction') NOT NULL, -- Added column to specify type of entity
    FOREIGN KEY (UserID) REFERENCES User(UserID),
    FOREIGN KEY (RestaurantID) REFERENCES Restaurant(RestaurantID),
    FOREIGN KEY (AttractionID) REFERENCES Attraction(AttractionID),
    CHECK ((EntityType = 'Restaurant' AND RestaurantID IS NOT NULL AND AttractionID IS NULL) OR
           (EntityType = 'Attraction' AND RestaurantID IS NULL AND AttractionID IS NOT NULL))
);

-- Create DISH Table
CREATE TABLE Dish (
    DishID INT AUTO_INCREMENT PRIMARY KEY,
    DishName VARCHAR(100) NOT NULL,
    DishDescription TEXT NOT NULL,
    TypicalPrice DECIMAL(10, 2) NOT NULL CHECK (TypicalPrice >= 0),
    RestaurantID INT NOT NULL,
    FOREIGN KEY (RestaurantID) REFERENCES Restaurant(RestaurantID)
);

-- Indexes to improve query performance
CREATE INDEX idx_user_nationality ON User(Nationality);
CREATE INDEX idx_flight_departure ON Flight(DepartureTime);
CREATE INDEX idx_attraction_region ON Attraction(RegionID);
CREATE INDEX idx_booking_date ON Booking(BookingDate);
CREATE INDEX idx_review_date ON Review(ReviewDate);

-- Populating User table
INSERT INTO User (Username, Email, Nationality) VALUES
('KofiAnnan', 'kofi.annan@example.com', 'Ghanaian'),
('AmaAtaAidoo', 'ama.aidoo@example.com', 'Ghanaian'),
('KwameNkrumah', 'kwame.nkrumah@example.com', 'Ghanaian'),
('EsiEdugyan', 'esi.edugyan@example.com', 'Ghanaian-Canadian'),
('JaneDoe', 'jane.doe@example.com', 'American'),
('LucaBianchi', 'luca.bianchi@example.com', 'Italian'),
('SophieLeclerc', 'sophie.leclerc@example.com', 'French'),
('YukiTakahashi', 'yuki.takahashi@example.com', 'Japanese'),
('AmitSharma', 'amit.sharma@example.com', 'Indian'),
('MariaGonzalez', 'maria.gonzalez@example.com', 'Spanish'),
('DavidSmith', 'david.smith@example.com', 'British'),
('AnnaIvanova', 'anna.ivanova@example.com', 'Russian'),
('OliviaJohnson', 'olivia.johnson@example.com', 'Canadian'),
('CarlosMartinez', 'carlos.martinez@example.com', 'Mexican'),
('KwesiAppiah', 'kwesi.appiah@example.com', 'Ghanaian'),
('NanaAmaMcBrown', 'nana.ama.mcbrown@example.com', 'Ghanaian'),
('JohnDumelo', 'john.dumelo@example.com', 'Ghanaian'),
('SerwaaAmihere', 'serwaa.amihere@example.com', 'Ghanaian'),
('Stonebwoy', 'stonebwoy@example.com', 'Ghanaian'),
('MzVee', 'mzvee@example.com', 'Ghanaian'),
('RihannaAidoo', 'rihanna.aidoo@example.com', 'Ghanaian'),
('DianaHamilton', 'diana.hamilton@example.com', 'Ghanaian');

-- Inserting data into Airport
INSERT INTO Airport (AirportID, AirportName, City, Country, AirportCode) VALUES
 (1, 'Kotoka International Airport', 'Accra', 'Ghana', 'ACC'),
(2, 'Kumasi International Airport', 'Kumasi', 'Ghana', 'KMS'),
(3, 'Tamale Airport', 'Tamale', 'Ghana', 'TML'),
(4, 'Takoradi Airport', 'Takoradi', 'Ghana', 'TKD'),
(5, 'Sunyani Airport', 'Sunyani', 'Ghana', 'NYI');

-- Populating Airline table
INSERT INTO Airline (AirlineName, AirlineCode, Country) VALUES
('Africa World Airlines', 'AW', 'Ghana'),
('Passion Air', 'PAS', 'Ghana'),
('Ethiopian Airlines', 'ET', 'Ethiopia'),
('Kenya Airways', 'KQ', 'Kenya'),
('South African Airways', 'SA', 'South Africa'),
('EgyptAir', 'MS', 'Egypt'),
('Royal Air Maroc', 'AT', 'Morocco'),
('Air Côte d''Ivoire', 'HF', 'Ivory Coast'),
('ASKY Airlines', 'KP', 'Togo'),
('RwandAir', 'WB', 'Rwanda');

-- populating the flight table
INSERT INTO Flight (FlightNumber, DepartureTime, ArrivalTime, Price, AirlineID, DepartureAirportID, ArrivalAirportID) VALUES
('AA123', '2024-07-21 08:00:00', '2024-07-21 10:30:00', 250.00, 1, 1, 2),
('BA456', '2024-07-21 14:00:00', '2024-07-21 16:30:00', 300.00, 2, 2, 3),
('DL789', '2024-07-22 09:15:00', '2024-07-22 11:45:00', 275.00, 3, 3, 1),
('UA101', '2024-07-22 17:30:00', '2024-07-22 20:00:00', 320.00, 4, 1, 4),
('LH202', '2024-07-23 07:00:00', '2024-07-23 12:00:00', 500.00, 5, 4, 5),
('AF303', '2024-07-23 22:00:00', '2024-07-24 04:30:00', 450.00, 6, 2, 3),
('QF404', '2024-07-24 11:00:00', '2024-07-24 18:00:00', 350.00, 7, 3, 4),
('AS505', '2024-07-24 16:15:00', '2024-07-24 20:45:00', 290.00, 8, 4, 1),
('NZ606', '2024-07-25 09:45:00', '2024-07-25 13:15:00', 275.00, 9, 1, 5),
('CI707', '2024-07-25 20:30:00', '2024-07-26 03:00:00', 600.00, 10, 5, 5);

INSERT INTO Region (RegionName, RegionDescription) VALUES
('Greater Accra', 'The Greater Accra Region is the smallest of the 16 administrative regions in Ghana, occupying a total land surface of 3,245 square kilometers.'),
('Ashanti', 'The Ashanti Region is located in south Ghana and is the third largest of 16 administrative regions.'),
('Central', 'The Central Region is one of the sixteen administrative regions of Ghana.'),
('Western', 'The Western Region is located in south Ghana.'),
('Northern', 'The Northern Region is one of the sixteen regions of Ghana.'),
('Eastern', 'The Eastern Region is a region in south Ghana and is one of the sixteen administrative regions of Ghana.'),
('Volta', 'The Volta Region is located in the eastern part of Ghana and it spans from the coastal plains on the Atlantic coast to the northern parts of the country.'),
('Upper East', 'The Upper East Region is located in north Ghana and is one of the sixteen administrative regions of Ghana.'),
('Upper West', 'The Upper West Region is located in north Ghana and is one of the sixteen administrative regions of Ghana.'),
('Bono', 'The Bono Region is a region of Ghana created from the Brong-Ahafo Region.'),
('Bono East', 'The Bono East Region is a region of Ghana created from the Brong-Ahafo Region.'),
('Ahafo', 'The Ahafo Region is a region of Ghana created from the Brong-Ahafo Region.'),
('Savannah', 'The Savannah Region is located in north Ghana and it is one of the sixteen administrative regions of Ghana.'),
('Western North', 'The Western North Region is one of the sixteen regions of Ghana created from the Western Region.'),
('Oti', 'The Oti Region is one of the sixteen regions of Ghana created from the Volta Region.'),
('North East', 'The North East Region is one of the sixteen regions of Ghana created from the Northern Region.');

-- Inserting data into Restaurant table for Accra
INSERT INTO Restaurant (RestaurantName, Cuisine, PriceRange, OpeningHours, RegionID) VALUES 
('Chop Bar', 'Ghanaian', 'Low', '10:00 - 22:00', 1),
('Urban Grill', 'Grill', 'High', '12:00 - 23:00', 1),
('Bistro 22', 'International', 'Medium', '11:00 - 23:00', 1),
('Santoku', 'Japanese', 'High', '12:00 - 22:30', 1),
('Shogun', 'Japanese', 'High', '12:00 - 23:00', 1),
('Skybar', 'International', 'High', '17:00 - 01:00', 1),
('Polo Club', 'International', 'Medium', '07:00 - 22:00', 1),
('Honeysuckle', 'Pub', 'Medium', '10:00 - 00:00', 1),
('Ilona', 'Mediterranean', 'High', '12:00 - 22:00', 1),
('Pate a Choux', 'Bakery', 'Low', '07:00 - 20:00', 1),
('La Piazza', 'Italian', 'Medium', '12:00 - 23:00', 1),
('Capitol Café & Restaurant', 'International', 'Medium', '08:00 - 22:00', 1),
('The Buka', 'African', 'Medium', '11:00 - 22:00', 1),
('Burger and Relish', 'Burgers', 'Medium', '12:00 - 23:00', 1),
('Kōzo Restaurant & Lounge', 'Asian Fusion', 'High', '17:00 - 23:00', 1),
('Tandoor Indian Restaurant', 'Indian', 'Medium', '12:00 - 22:00', 1),
('Chase', 'Continental', 'Medium', '10:00 - 23:00', 1),
('Mama Mia Pizzeria', 'Italian', 'Medium', '12:00 - 22:00', 1),
('Bistro Cafe', 'Cafe', 'Medium', '08:00 - 20:00', 1),
('Living Room', 'Ghanaian', 'Medium', '10:00 - 22:00', 1),
('Vine Lounge', 'Continental', 'Medium', '10:00 - 22:00', 1),
('Café Kwae', 'Cafe', 'Medium', '07:00 - 19:00', 1),
('Starbites Food & Drink', 'Continental', 'Medium', '09:00 - 22:00', 1),
('Pinocchio & La Piazza', 'Italian', 'Medium', '11:00 - 23:00', 1),
('Oriental Restaurant', 'Chinese', 'Medium', '11:00 - 22:00', 1),
('Chez Afrique', 'Ghanaian', 'Low', '10:00 - 22:00', 1),
('Lord of the Wings', 'American', 'Medium', '12:00 - 23:00', 1),
('Vida e Caffè', 'Cafe', 'Medium', '07:00 - 20:00', 1),
('Luna', 'Continental', 'High', '17:00 - 23:00', 1),
('Bistro 233', 'International', 'Medium', '11:00 - 23:00', 1),
('Fat Fish', 'Seafood', 'High', '12:00 - 23:00', 1),
('DNR Turkish Restaurant', 'Turkish', 'Medium', '11:00 - 23:00', 1),
('AM&PM', 'Breakfast & Brunch', 'Medium', '08:00 - 22:00', 1),
('La Chaumière', 'French', 'High', '12:00 - 22:00', 1),
('Marwako Fast Food', 'Lebanese', 'Low', '09:00 - 22:00', 1),
('Simret Ethiopian Restaurant', 'Ethiopian', 'Medium', '12:00 - 22:00', 1),
('El Padrino', 'Steakhouse', 'High', '12:00 - 23:00', 1),
('Country Club', 'Continental', 'High', '10:00 - 22:00', 1),
('Papillon Restaurant at Kempinski', 'International', 'High', '24 Hours', 1),
('Sankofa Restaurant at Movenpick', 'International', 'High', '24 Hours', 1),
('Aboude Fast Food', 'Fast Food', 'Low', '09:00 - 23:00', 2),
('Moti Mahal', 'Indian', 'Medium', '12:00 - 22:00', 2),
('Vic Baboo’s Cafe', 'International', 'Low', '08:00 - 22:00', 2),
('The View Bar and Grill', 'Grill', 'High', '11:00 - 23:00', 2),
('Golden Bean Restaurant', 'Ghanaian', 'Medium', '10:00 - 22:00', 2),
('Golden Tulip', 'International', 'High', '24 Hours', 2),
('Piri Piri Chicken', 'Fast Food', 'Low', '10:00 - 22:00', 2),
('Micky’s Restaurant', 'International', 'Medium', '11:00 - 23:00', 2),
('Chopsticks', 'Chinese', 'Medium', '12:00 - 22:00', 2),
('Royal Park', 'Continental', 'Medium', '11:00 - 23:00', 2),
('The Pitch', 'Grill', 'High', '11:00 - 23:00', 2);

INSERT INTO Attraction (AttractionName, AttractionDescription, Rating, RegionID, AttractionType, EntryFee) VALUES
('Kwame Nkrumah Memorial Park', 'A memorial park dedicated to the prominent Ghanaian leader Kwame Nkrumah.', 4.5, 1, 'Historical Site', 15.00),
('Cape Coast Castle', 'A castle with a rich history related to the trans-Atlantic slave trade.', 4.7, 3, 'Historical Site', 20.00),
('Kakum National Park', 'A national park with a canopy walkway.', 4.8, 3, 'Nature Reserve', 18.00),
('Elmina Castle', 'One of the oldest European buildings in sub-Saharan Africa.', 4.6, 3, 'Historical Site', 28.00),
('Tamale Central Market', 'A bustling market in the Northern Region.', 4.3, 5, 'Market', 16.00),
('Manhyia Palace Museum', 'A museum showcasing Ashanti history and culture.', 4.6, 2, 'Museum', 30.00),
('Lake Bosomtwe', 'A natural lake formed in a meteorite impact crater.', 4.7, 2, 'Natural Attraction', 20.00),
('Wli Waterfalls', 'The highest waterfall in Ghana.', 4.9, 7, 'Natural Attraction', 22.00),
('Mole National Park', 'The largest wildlife park in Ghana.', 4.8, 5, 'National Park', 25.00),
('Nzulezo Stilt Village', 'A village built on stilts over a lagoon.', 4.7, 4, 'Cultural Site', 17.00),
('Boti Falls', 'A twin waterfall located in the Eastern Region.', 4.6, 6, 'Natural Attraction', 15.00),
('Tafi Atome Monkey Sanctuary', 'A sanctuary for endangered Mona monkeys.', 4.5, 7, 'Wildlife Sanctuary', 15.00),
('Larabanga Mosque', 'The oldest mosque in Ghana and one of the oldest in West Africa.', 4.6, 5, 'Religious Site', 20.00),
('Akosombo Dam', 'A hydroelectric dam on the Volta River.', 4.5, 7, 'Engineering Marvel', 24.00),
('Paga Crocodile Pond', 'A pond where crocodiles are revered and can be petted.', 4.3, 8, 'Wildlife Sanctuary', 15.00),
('Kintampo Waterfalls', 'A beautiful waterfall in the Bono East Region.', 4.7, 10, 'Natural Attraction', 33.00),
('Wechiau Hippo Sanctuary', 'A sanctuary for hippos on the Black Volta River.', 4.6, 9, 'Wildlife Sanctuary', 16.00),
('Volta Estuary', 'A scenic area where the Volta River meets the Atlantic Ocean.', 4.6, 7, 'Scenic Spot', 19.00),
('Fort Amsterdam', 'A historical fort in the Central Region.', 4.5, 3, 'Historical Site', 24.00),
('Bunso Arboretum', 'A botanical garden and forest reserve in the Eastern Region.', 4.6, 6, 'Nature Reserve', 30.00);


INSERT INTO Nightclub (AttractionID, MusicType, Location, OpeningHours) VALUES 
(1, 'Afrobeat', 'Twist Nightclub, Cantonments', '22:00 - 05:00'),
(2, 'Hip Hop', 'Firefly Lounge Bar, Osu', '18:00 - 02:00'),
(3, 'Reggae', 'Carbon Nightclub, Airport', '22:00 - 04:00'),
(4, 'Hip Hop & RnB', 'Plot Seven Nightclub, Nyaniba Estates, Osu', '22:00 - 04:00'),
(5, 'House', 'Skybar 25, Airport', '17:00 - 01:00'),
(6, 'Afrobeat & Hip Hop', 'Firefly Lounge Bar, Osu', '18:00 - 02:00'),
(7, 'Jazz & Soul', 'Café Kwae, Airport Residential Area', '07:00 - 20:00'),
(8, 'Mixed', 'Venus Lounge, East Legon', '18:00 - 02:00'),
(9, 'Afrobeat', 'Club Onyx, Cantonments', '22:00 - 05:00'),
(10, 'Hip Hop & RnB', 'Carbon Nightclub, Airport', '22:00 - 04:00'),
(11, 'Mixed', 'Coco Lounge, Airport', '10:00 - 02:00'),
(12, 'Jazz', '+233 Jazz Bar & Grill, North Ridge', '18:00 - 01:00'),
(13, 'Live Band', 'Polo Club Restaurant & Lounge, Airport', '12:00 - 23:00'),
(14, 'Afrobeat & Dancehall', 'Ace Tantra, Osu', '22:00 - 04:00'),
(15, 'House & EDM', 'Bloom Bar, Osu', '18:00 - 02:00');




-- Inserting data into Dish table
INSERT INTO Dish (DishName, DishDescription, TypicalPrice, RestaurantID) VALUES 
('Fufu and Light Soup', 'Traditional Ghanaian dish made from cassava and plantains with spicy light soup', 20.00, 1), -- Chop Bar
('Grilled Steak', 'Juicy grilled steak with a side of vegetables', 50.00, 2), -- Urban Grill
('Pasta Carbonara', 'Creamy pasta with bacon and cheese', 30.00, 3), -- Bistro 22
('Sushi Platter', 'Assorted sushi platter with fresh seafood', 60.00, 4), -- Santoku
('Ramen', 'Japanese noodle soup with pork, egg, and vegetables', 40.00, 5), -- Shogun
('Chicken Caesar Salad', 'Grilled chicken with romaine lettuce and Caesar dressing', 25.00, 6), -- Skybar
('Club Sandwich', 'Triple-layered sandwich with chicken, bacon, lettuce, and tomato', 20.00, 7), -- Polo Club
('Fish and Chips', 'Crispy battered fish served with fries', 18.00, 8), -- Honeysuckle
('Mediterranean Platter', 'Assorted Mediterranean appetizers and dips', 45.00, 9), -- Ilona
('Croissants', 'Freshly baked buttery croissants', 10.00, 10), -- Pate a Choux
('Margherita Pizza', 'Classic pizza with tomatoes, mozzarella, and basil', 28.00, 11), -- La Piazza
('Grilled Salmon', 'Salmon fillet with a lemon butter sauce', 35.00, 12), -- Capitol Café & Restaurant
('Jollof Rice', 'Spicy West African rice dish with chicken', 25.00, 13), -- The Buka
('Cheeseburger', 'Juicy beef burger with cheese, lettuce, and tomato', 20.00, 14), -- Burger and Relish
('Spring Rolls', 'Crispy spring rolls with a sweet chili dipping sauce', 30.00, 15), -- Kōzo Restaurant & Lounge
('Butter Chicken', 'Indian curry with chicken in a creamy tomato sauce', 25.00, 16), -- Tandoor Indian Restaurant
('Mixed Grill', 'Assortment of grilled meats with vegetables', 40.00, 17), -- Chase
('Pepperoni Pizza', 'Pizza topped with pepperoni slices and cheese', 25.00, 18), -- Mama Mia Pizzeria
('Cappuccino', 'Espresso-based coffee drink with steamed milk foam', 10.00, 19), -- Bistro Cafe
('Waakye', 'Ghanaian dish made with rice and beans served with assorted sides', 22.00, 20), -- Living Room
('Pasta Alfredo', 'Creamy pasta with chicken and parmesan', 28.00, 21), -- Vine Lounge
('Latte', 'Coffee drink with espresso and steamed milk', 8.00, 22), -- Café Kwae
('Grilled Chicken', 'Grilled chicken served with a side of fries', 20.00, 23), -- Starbites Food & Drink
('Lasagna', 'Baked pasta with layers of meat, cheese, and tomato sauce', 28.00, 24), -- Pinocchio & La Piazza
('Sweet and Sour Pork', 'Pork cooked in a sweet and sour sauce with vegetables', 25.00, 25), -- Oriental Restaurant
('Banku and Tilapia', 'Ghanaian dish made from fermented corn served with grilled tilapia', 18.00, 26), -- Chez Afrique
('Buffalo Wings', 'Spicy chicken wings served with a blue cheese dip', 22.00, 27), -- Lord of the Wings
('Espresso', 'Strong black coffee made by forcing steam through ground coffee beans', 8.00, 28), -- Vida e Caffè
('Filet Mignon', 'Tender beef steak with a side of mashed potatoes', 60.00, 29), -- Luna
('Seafood Platter', 'Assorted seafood served with dipping sauces', 55.00, 30), -- Bistro 233
('Grilled Lobster', 'Lobster grilled with garlic butter', 70.00, 31), -- Fat Fish
('Turkish Kebab', 'Marinated meat grilled on skewers', 30.00, 32), -- DNR Turkish Restaurant
('Pancakes', 'Fluffy pancakes served with maple syrup', 15.00, 33), -- AM&PM
('Coq au Vin', 'French dish of chicken braised with wine, mushrooms, and garlic', 45.00, 34), -- La Chaumière
('Falafel Wrap', 'Lebanese wrap filled with falafel and vegetables', 15.00, 35), -- Marwako Fast Food
('Doro Wat', 'Spicy Ethiopian chicken stew served with injera', 25.00, 36), -- Simret Ethiopian Restaurant
('Ribeye Steak', 'Grilled ribeye steak with a side of vegetables', 65.00, 37), -- El Padrino
('Beef Stroganoff', 'Beef cooked in a creamy mushroom sauce served over noodles', 50.00, 38), -- Country Club
('All-Day Breakfast', 'Breakfast platter available all day', 35.00, 39), -- Papillon Restaurant at Kempinski
('Buffet', 'Assortment of dishes available at the buffet', 50.00, 40), -- Sankofa Restaurant at Movenpick
('Shawarma', 'Middle Eastern dish with meat and vegetables wrapped in flatbread', 12.00, 41), -- Aboude Fast Food
('Chicken Tikka Masala', 'Indian dish of grilled chicken in a spiced curry sauce', 25.00, 42), -- Moti Mahal
('Veggie Burger', 'Burger made with a vegetable patty', 10.00, 43), -- Vic Baboo’s Cafe
('BBQ Ribs', 'Ribs cooked with a smoky barbecue sauce', 50.00, 44), -- The View Bar and Grill
('Kelewele', 'Spicy fried plantains', 15.00, 45), -- Golden Bean Restaurant
('Buffet', 'All-you-can-eat buffet with a variety of dishes', 60.00, 46), -- Golden Tulip
('Piri Piri Chicken', 'Spicy chicken marinated in piri piri sauce', 12.00, 47), -- Piri Piri Chicken
('Stir Fry Noodles', 'Noodles stir-fried with vegetables and choice of protein', 20.00, 48), -- Micky’s Restaurant
('Sweet and Sour Chicken', 'Chicken cooked in a sweet and sour sauce', 25.00, 49), -- Chopsticks
('Grilled Fish', 'Fish grilled with lemon and herbs', 30.00, 50), -- Royal Park
('BBQ Pork Ribs', 'Pork ribs cooked with barbecue sauce', 50.00, 51); -- The Pitch

-- Inserting data into Review table about the restaurants
INSERT INTO Review (UserID, ReviewDate, ReviewComment, Rating, RestaurantID, AttractionID) VALUES 
(1, '2024-03-01', 'Great food and friendly service!', 4.5, 1, NULL), -- Chop Bar
(2, '2024-03-02', 'Amazing steak, cooked to perfection!', 5.0, 2, NULL), -- Urban Grill
(3, '2024-03-03', 'Lovely ambiance and delicious pasta.', 4.0, 3, NULL), -- Bistro 22
(4, '2024-03-04', 'The sushi was fresh and tasty.', 4.8, 4, NULL), -- Santoku
(5, '2024-03-05', 'Enjoyed the ramen, very authentic.', 4.7, 5, NULL), -- Shogun
(6, '2024-03-06', 'The salad was fresh and the view is great.', 4.3, 6, NULL), -- Skybar
(7, '2024-03-07', 'Great club sandwich and a relaxing atmosphere.', 4.2, 7, NULL), -- Polo Club
(8, '2024-03-08', 'Best fish and chips in town!', 4.5, 8, NULL), -- Honeysuckle
(9, '2024-03-09', 'The Mediterranean platter was delightful.', 4.6, 9, NULL), -- Ilona
(10, '2024-03-10', 'Loved the croissants, very buttery and flaky.', 4.0, 10, NULL), -- Pate a Choux
(11, '2024-03-11', 'The pizza was perfect with a crispy crust.', 4.4, 11, NULL), -- La Piazza
(12, '2024-03-12', 'The salmon was cooked to perfection.', 4.7, 12, NULL), -- Capitol Café & Restaurant
(13, '2024-03-13', 'Jollof rice was flavorful and spicy.', 4.2, 13, NULL), -- The Buka
(14, '2024-03-14', 'Cheeseburger was juicy and tasty.', 4.3, 14, NULL), -- Burger and Relish
(15, '2024-03-15', 'The spring rolls were crispy and delicious.', 4.5, 15, NULL), -- Kōzo Restaurant & Lounge
(16, '2024-03-16', 'Loved the butter chicken, very creamy.', 4.6, 16, NULL), -- Tandoor Indian Restaurant
(17, '2024-03-17', 'The mixed grill was a meat lover’s dream.', 4.8, 17, NULL), -- Chase
(18, '2024-03-18', 'Pepperoni pizza was delicious and cheesy.', 4.4, 18, NULL), -- Mama Mia Pizzeria
(1, '2024-03-19', 'Cappuccino was smooth and rich.', 4.1, 19, NULL), -- Bistro Cafe
(2, '2024-03-20', 'Waakye was very tasty and well-prepared.', 4.3, 20, NULL); -- Living Room

-- inserting into Review for attractions
INSERT INTO Review (UserID, ReviewDate, ReviewComment, Rating, RestaurantID, AttractionID, EntityType) VALUES
(1, '2024-03-01', 'The park is beautifully maintained and very educational.', 4.5, NULL, 1, 'Attraction'), -- Kwame Nkrumah Memorial Park
(2, '2024-03-02', 'A very moving experience learning about the slave trade.', 4.7, NULL, 2, 'Attraction'), -- Cape Coast Castle
(3, '2024-03-03', 'The canopy walkway was an incredible experience.', 4.8, NULL, 3, 'Attraction'), -- Kakum National Park
(4, '2024-03-04', 'Impressive historical site with rich history.', 4.6, NULL, 4, 'Attraction'), -- Elmina Castle
(5, '2024-03-05', 'A great place to experience local culture and hustle.', 4.3, NULL, 5, 'Attraction'), -- Tamale Central Market
(6, '2024-03-06', 'Fascinating museum with lots of historical artifacts.', 4.6, NULL, 6, 'Attraction'), -- Manhyia Palace Museum
(7, '2024-03-07', 'The lake is serene and beautiful, worth the visit.', 4.7, NULL, 7, 'Attraction'), -- Lake Bosomtwe
(8, '2024-03-08', 'The highest waterfall in Ghana – simply breathtaking.', 4.9, NULL, 8, 'Attraction'), -- Wli Waterfalls
(9, '2024-03-09', 'Amazing wildlife park with diverse species.', 4.8, NULL, 9, 'Attraction'), -- Mole National Park
(10, '2024-03-10', 'Unique village on stilts, very interesting to see.', 4.7, NULL, 10, 'Attraction'), -- Nzulezo Stilt Village
(11, '2024-03-11', 'Beautiful twin waterfall in a lush setting.', 4.6, NULL, 11, 'Attraction'), -- Boti Falls
(12, '2024-03-12', 'A great place to see monkeys up close and personal.', 4.5, NULL, 12, 'Attraction'), -- Tafi Atome Monkey Sanctuary
(13, '2024-03-13', 'An impressive structure with historical significance.', 4.6, NULL, 13, 'Attraction'), -- Larabanga Mosque
(14, '2024-03-14', 'An engineering marvel with great views of the Volta River.', 4.5, NULL, 14, 'Attraction'), -- Akosombo Dam
(15, '2024-03-15', 'Unique experience interacting with crocodiles.', 4.3, NULL, 15, 'Attraction'), -- Paga Crocodile Pond
(16, '2024-03-16', 'A stunning waterfall in a picturesque location.', 4.7, NULL, 16, 'Attraction'), -- Kintampo Waterfalls
(17, '2024-03-17', 'Hippos in their natural habitat – a must-see.', 4.6, NULL, 17, 'Attraction'), -- Wechiau Hippo Sanctuary
(18, '2024-03-18', 'Beautiful spot where the river meets the sea.', 4.6, NULL, 18, 'Attraction'), -- Volta Estuary
(5, '2024-03-19', 'Historical fort with great views and history.', 4.5, NULL, 19, 'Attraction'), -- Fort Amsterdam
(10, '2024-03-20', 'A lovely botanical garden and forest reserve.', 4.6, NULL, 20, 'Attraction'); -- Bunso Arboretum


-- Populating Booking Table with new data
INSERT INTO Booking (UserID, BookingDate, TotalCost, FlightID, RestaurantID, AttractionID) VALUES
(1, '2024-07-10', 300.00, 1, 1, NULL),
(2, '2024-07-11', 450.00, 2, 1, NULL),
(1, '2024-07-12', 500.00, 3, NULL, 1),
(3, '2024-07-13', 700.00, 4, NULL, 2),
(2, '2024-07-14', 600.00, 5, 2, NULL),
(3, '2024-07-15', 550.00, 2, NULL, 3),
(4, '2024-07-16', 650.00, 1, 2, NULL),
(5, '2024-07-17', 750.00, 3, NULL, 5),
(1, '2024-07-18', 800.00, 4, 3, NULL),
(2, '2024-07-19', 850.00, 5, NULL, 4),
(4, '2024-07-10', 300.00, 1, 1, NULL),
(5, '2024-07-11', 450.00, 2, 1, NULL),
(7, '2024-07-12', 500.00, 3, NULL, 1),
(4, '2024-07-10', 300.00, 1, 1, NULL),
(12, '2024-07-11', 450.00, 2, 1, NULL),
(4, '2024-07-12', 500.00, 3, NULL, 1);




-- Find all users
SELECT * FROM User;

-- Find all bookings
SELECT * FROM Booking;

-- Find all flights
SELECT * FROM Flight;

-- Find all airports
SELECT * FROM Airport;

-- Find all airlines
SELECT * FROM Airline;

-- Find all attractions
SELECT * FROM Attraction;

-- Find all nightclubs
SELECT * FROM Nightclub;

-- Find all restaurants
SELECT * FROM Restaurant;

-- Find all regions
SELECT * FROM Region;

-- Find all reviews
SELECT * FROM Review;

-- Find all dishes
SELECT * FROM Dish;


-- flight details of flights departing from 'Kotoka International Airport'.
SELECT FlightNumber, DepartureTime, ArrivalTime, Price
FROM Flight
WHERE DepartureAirportID = (SELECT AirportID FROM Airport WHERE AirportName = 'Kotoka International Airport');

-- get the number of attractions in each region.
SELECT Region.RegionName, COUNT(Attraction.AttractionID) AS AttractionCount
FROM Region
LEFT JOIN Attraction ON Region.RegionID = Attraction.RegionID
GROUP BY Region.RegionName;

-- listing users and their bookings with total costs for bookings made in July 2024.
SELECT User.UserName, Booking.BookingDate, Booking.TotalCost
FROM User
JOIN Booking ON User.UserID = Booking.UserID
WHERE Booking.BookingDate BETWEEN '2024-07-01' AND '2024-07-31';

-- finding the names of dishes and their respective restaurant names located in the 'Greater Accra' region.
SELECT Dish.DishName, Restaurant.RestaurantName AS RestaurantName
FROM Dish
JOIN Restaurant ON Dish.RestaurantID = Restaurant.RestaurantID
WHERE Restaurant.RegionID = (SELECT RegionID FROM Region WHERE RegionName = 'Greater Accra');

-- listing nightclubs featuring 'Afrobeat' music.
SELECT Attraction.AttractionName, Nightclub.Location, Nightclub.OpeningHours
FROM Nightclub
JOIN Attraction ON Nightclub.AttractionID = Attraction.AttractionID
WHERE Nightclub.MusicType = 'Afrobeat';

-- finding the average rating of each restaurant and display the top 5 restaurants with the highest average rating.
SELECT Restaurant.RestaurantName, AVG(Review.Rating) AS AverageRating
FROM Restaurant
JOIN Review ON Restaurant.RestaurantID = Review.RestaurantID
WHERE Review.EntityType = 'Restaurant'
GROUP BY Restaurant.RestaurantName
ORDER BY AverageRating DESC
LIMIT 5;




