import streamlit as st
import pandas as pd
import mysql.connector

# Database connection


cnx = mysql.connector.connect(
    user='root',
    password='see2@#ease',
    host='localhost',
    database='TravelManagement'
)

# Create a cursor object
cursor = cnx.cursor()

# Function to get data from a query
def get_data(query):
    cursor.execute(query)
    data = cursor.fetchall()
    columns = [desc[0] for desc in cursor.description]
    df = pd.DataFrame(data, columns=columns)
    return df

# Functions to get flight, restaurant, and attraction options
def get_flight_options():
    query = "SELECT FlightID, FlightNumber FROM Flight"
    return get_data(query)

def get_restaurant_options():
    query = "SELECT RestaurantID, RestaurantName FROM Restaurant"
    return get_data(query)

def get_attraction_options():
    query = "SELECT AttractionID, AttractionName FROM Attraction"
    return get_data(query)

# Function to make a booking
def make_booking(user_id, booking_date, flight_id=None, restaurant_id=None, attraction_id=None):
    query = "INSERT INTO Booking (UserID, BookingDate, TotalCost) VALUES (%s, %s, %s)"
    total_cost = 0

    if flight_id:
        query_flight = f"SELECT Price FROM Flight WHERE FlightID = {flight_id}"
        cursor.execute(query_flight)
        flight_price = cursor.fetchone()[0]
        total_cost += flight_price

    if restaurant_id:
        query_restaurant = f"SELECT TypicalPrice FROM Dish WHERE RestaurantID = {restaurant_id}"
        cursor.execute(query_restaurant)
        restaurant_price = cursor.fetchone()[0]
        total_cost += restaurant_price

    if attraction_id:
        query_attraction = f"SELECT EntryFee FROM Attraction WHERE AttractionID = {attraction_id}"
        cursor.execute(query_attraction)
        attraction_price = cursor.fetchone()[0]
        total_cost += attraction_price

    cursor.execute(query, (user_id, booking_date, total_cost))
    cnx.commit()

# Function to get bookings with optional filtering by user ID
def get_bookings(user_id=None):
    if user_id:
        query = "SELECT * FROM Booking WHERE UserID = %s"
        cursor.execute(query, (user_id,))
    else:
        query = "SELECT * FROM Booking"
        cursor.execute(query)
    data = cursor.fetchall()
    columns = [desc[0] for desc in cursor.description]
    df = pd.DataFrame(data, columns=columns)
    return df

# Function to get bookings for a specific user
def get_bookings_by_user_id(user_id):
    query = "SELECT BookingID, BookingDate, TotalCost FROM Booking WHERE UserID = %s"
    cursor.execute(query, (user_id,))
    data = cursor.fetchall()
    columns = [desc[0] for desc in cursor.description]
    df = pd.DataFrame(data, columns=columns)
    return df

# Function to get user names
def get_user_names():
    query = "SELECT UserID, Username FROM User"
    return get_data(query)

# Function to delete a booking by ID
def delete_booking_by_id(booking_id):
    query = "DELETE FROM Booking WHERE BookingID = %s"
    cursor.execute(query, (booking_id,))
    cnx.commit()

# Streamlit interface
st.title("Travel Management Database")

st.sidebar.title("Navigation")

page = st.sidebar.selectbox("Choose a page", ["Home", "View Data", "Queries", "Add User", "Make Booking", "Check Flights", "Delete Booking", "Check Bookings"])

if page == "Home":
    st.write("Welcome to the Travel Management Database interface.")
elif page == "View Data":
    table_name = st.selectbox("Choose a table", ["User", "Booking", "Flight", "Airport", "Airline", "Attraction", "Nightclub", "Restaurant", "Region", "Review", "Dish"])
    query = f"SELECT * FROM {table_name}"
    df = get_data(query)
    st.write(df)
elif page == "Queries":
    query_name = st.selectbox("Choose a query", ["Flight Details", "Attraction Count by Region", "User Bookings", "Dish and Restaurant Names", "Nightclub Details", "Top 5 Restaurants by Rating"])
    if query_name == "Flight Details":
        query = """
            SELECT FlightNumber, DepartureTime, ArrivalTime, Price
            FROM Flight
            WHERE DepartureAirportID = (SELECT AirportID FROM Airport WHERE AirportName = 'Kotoka International Airport')
        """
        df = get_data(query)
        st.write(df)
    elif query_name == "Attraction Count by Region":
        query = """
            SELECT Region.RegionName, COUNT(Attraction.AttractionID) AS AttractionCount
            FROM Region
            LEFT JOIN Attraction ON Region.RegionID = Attraction.RegionID
            GROUP BY Region.RegionName
        """
        df = get_data(query)
        st.write(df)
    elif query_name == "User Bookings":
        query = """
            SELECT User.Username, Booking.BookingDate, Booking.TotalCost
            FROM User
            JOIN Booking ON User.UserID = Booking.UserID
            WHERE Booking.BookingDate BETWEEN '2024-07-01' AND '2024-07-31'
        """
        df = get_data(query)
        st.write(df)
    elif query_name == "Dish and Restaurant Names":
        query = """
            SELECT Dish.DishName, Restaurant.RestaurantName AS RestaurantName
            FROM Dish
            JOIN Restaurant ON Dish.RestaurantID = Restaurant.RestaurantID
            WHERE Restaurant.RegionID = (SELECT RegionID FROM Region WHERE RegionName = 'Greater Accra')
        """
        df = get_data(query)
        st.write(df)
    elif query_name == "Nightclub Details":
        query = """
            SELECT Attraction.AttractionName, Nightclub.Location, Nightclub.OpeningHours
            FROM Nightclub
            JOIN Attraction ON Nightclub.AttractionID = Attraction.AttractionID
            WHERE Nightclub.MusicType = 'Afrobeat'
        """
        df = get_data(query)
        st.write(df)
    elif query_name == "Top 5 Restaurants by Rating":
        query = """
            SELECT Restaurant.RestaurantName, AVG(Review.Rating) AS AverageRating
            FROM Restaurant
            JOIN Review ON Restaurant.RestaurantID = Review.RestaurantID
            WHERE Review.EntityType = 'Restaurant'
            GROUP BY Restaurant.RestaurantName
            ORDER BY AverageRating DESC
            LIMIT 5
        """
        df = get_data(query)
        st.write(df)
elif page == "Add User":
    st.subheader("Add a New User")
    user_name = st.text_input("Username")
    user_email = st.text_input("Email")
    user_nationality = st.text_input("Nationality")
    if st.button("Add User"):
        query = "INSERT INTO User (Username, Email, Nationality) VALUES (%s, %s, %s)"
        cursor.execute(query, (user_name, user_email, user_nationality))
        cnx.commit()
        st.success("User added successfully!")
elif page == "Check Flights":
    st.subheader("Check Flights from Kotoka International Airport")
    query = """
        SELECT FlightNumber, DepartureTime, ArrivalTime, Price
        FROM Flight
        WHERE DepartureAirportID = (SELECT AirportID FROM Airport WHERE AirportName = 'Kotoka International Airport')
    """
    df = get_data(query)
    st.write(df)
elif page == "Make Booking":
    st.subheader("Make a New Booking")
    user_id = st.number_input("User ID", min_value=1)
    booking_date = st.date_input("Booking Date")

    flight_id = None
    if st.checkbox("Include a Flight"):
        flight_options = get_flight_options()
        flight_name_to_id = dict(zip(flight_options["FlightNumber"], flight_options["FlightID"]))
        flight_name = st.selectbox("Flight", flight_options["FlightNumber"])
        flight_id = flight_name_to_id[flight_name]

    restaurant_id = None
    if st.checkbox("Include a Restaurant"):
        restaurant_options = get_restaurant_options()
        restaurant_name_to_id = dict(zip(restaurant_options["RestaurantName"], restaurant_options["RestaurantID"]))
        restaurant_name = st.selectbox("Restaurant", restaurant_options["RestaurantName"])
        restaurant_id = restaurant_name_to_id[restaurant_name]

    attraction_id = None
    if st.checkbox("Include an Attraction"):
        attraction_options = get_attraction_options()
        attraction_name_to_id = dict(zip(attraction_options["AttractionName"], attraction_options["AttractionID"]))
        attraction_name = st.selectbox("Attraction", attraction_options["AttractionName"])
        attraction_id = attraction_name_to_id[attraction_name]

    if st.button("Make Booking"):
        make_booking(user_id, booking_date, flight_id, restaurant_id, attraction_id)
        st.success("Booking made successfully!")
elif page == "Check Bookings":
    st.subheader("Check Bookings")
    user_options = get_user_names()
    user_name_to_id = dict(zip(user_options["Username"], user_options["UserID"]))
    user_name = st.selectbox("User Name", user_options["Username"])
    user_id = user_name_to_id.get(user_name, None)
    
    if st.button("View Bookings"):
        if user_id:
            df = get_bookings(user_id)
            st.write(df)
        else:
            st.write("User not found")
elif page == "Delete Booking":
    st.subheader("Delete a Specific Booking by User Name")
    user_options = get_user_names()
    user_name_to_id = dict(zip(user_options["Username"], user_options["UserID"]))
    user_name = st.selectbox("User Name", user_options["Username"])
    user_id = user_name_to_id.get(user_name, None)

    if user_id:
        bookings_df = get_bookings_by_user_id(user_id)
        if not bookings_df.empty:
            booking_options = bookings_df.apply(lambda row: f"Booking ID: {row['BookingID']} - Date: {row['BookingDate']} - Total Cost: {row['TotalCost']}", axis=1).tolist()
            booking_dict = dict(zip(booking_options, bookings_df["BookingID"].tolist()))
            booking_selection = st.selectbox("Select Booking to Delete", booking_options)
            booking_id = booking_dict[booking_selection]

            if st.button("Delete Booking"):
                delete_booking_by_id(booking_id)
                st.success("Booking deleted successfully!")
        else:
            st.write("No bookings found for this user.")
    else:
        st.write("User not found.")

# Close the database connection
cnx.close()
