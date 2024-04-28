import requests
import xml.etree.ElementTree as ET
import itertools
from datetime import datetime, timedelta
import requests
import requests
import itertools



def translate_time_to_minutes(time_string):
    parts = time_string.split()
    hours = 0
    minutes = 0
    for i in range(len(parts)):
        if parts[i] == "hour" or parts[i] == "hours":
            if i > 0 and parts[i - 1].isdigit():
                hours = int(parts[i - 1])
            else:
                hours = int(parts[i - 1][:-1])
        elif parts[i] in ["minute", "minutes", "min", "mins"]:
            if i > 0 and parts[i - 1].isdigit():
                minutes = int(parts[i - 1])
            else:
                minutes = int(parts[i - 1][:-1])
    total_minutes = hours * 60 + minutes
    return (total_minutes)



class Flight:
    def __init__(self, flight_number_iata: int, airline_code_iata: str, departure_date: str):
        __secret = '439229a6-134d-47f0-b877-521ab5e6f16d'
        self.airline_code=airline_code_iata
        self.airlineflightnum=str(flight_number_iata)
        self.flNum = airline_code_iata + str(flight_number_iata)
        self.departure_date = departure_date

        response_raw = requests.get(f'https://airlabs.co/api/v9/flight?api_key={__secret}&flight_iata={self.flNum}').json()
        print(response_raw)
        flight_info = response_raw.get('response', {})


        self.arr_city = flight_info.get('arr_city')
        self.dep_city = flight_info.get('dep_city')
        self.arr_iata = flight_info.get('arr_iata')
        self.dep_iata = flight_info.get('dep_iata')
        self.arr_name = flight_info.get('arr_name')
        self.dep_name = flight_info.get('dep_name')
        self.arr_time=''
        url = f"https://timetable-lookup.p.rapidapi.com/TimeTable/{self.dep_iata}/{self.arr_iata}/{self.departure_date}/"

        querystring = {"Airline": f"{self.airline_code}", "FlightNumber": f"{self.airlineflightnum}"}

        headers = {
            "X-RapidAPI-Key": "805c930cb9msha2920bc65e030a3p12d6e0jsnb8747b56b487",
            "X-RapidAPI-Host": "timetable-lookup.p.rapidapi.com"
        }

        response = requests.get(url, headers=headers, params=querystring)


        print(f'HELOOOOOOO {url}, {querystring}')
        xml_content = response.text
        print(xml_content)

        start_index = xml_content.find('FLSArrivalDateTime')
        if start_index != -1:
            start_index += len('FLSArrivalDateTime')+13
            end_index = (xml_content.find('FLSArrivalTimeOffset', start_index))-8
        if end_index != -1:
            self.arr_time= xml_content[start_index:end_index]



        start_index1 = xml_content.find('FLSDepartureDateTime')    
        if start_index1 != -1:
            start_index1 += len('FLSDepartureDateTime')+13
            end_index1 = (xml_content.find('FLSDepartureTimeOffset', start_index1))-8
        if end_index1 != -1:
            self.dep_time= xml_content[start_index1:end_index1]    



            

    def get_initial_info(self,):
        return [self.dep_city, self.arr_city, self.dep_name, self.arr_name, self.dep_time, self.arr_time, self.dep_iata ,self.arr_iata ]








class GoogleMapsTravelTimeCalculator:
    def __init__(self, api_key):
        self.api_key = api_key

    def translate_time_to_minutes(self, time_string):
        parts = time_string.split()
        hours = 0
        minutes = 0
        for i in range(len(parts)):
            if parts[i] == "hour" or parts[i] == "hours":
                if i > 0 and parts[i - 1].isdigit():
                    hours = int(parts[i - 1])
                else:
                    hours = int(parts[i - 1][:-1])
            elif parts[i] in ["minute", "minutes", "min", "mins"]:
                if i > 0 and parts[i - 1].isdigit():
                    minutes = int(parts[i - 1])
                else:
                    minutes = int(parts[i - 1][:-1])
        total_minutes = hours * 60 + minutes
        return total_minutes

    def get_coordinates(self, place):
        endpoint = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json"
        params = {
            "input": place,
            "inputtype": "textquery",
            "fields": "geometry/location",
            "key": self.api_key,
        }

        response = requests.get(endpoint, params=params)
        result = response.json()

        if result["status"] == "OK":
            location = result["candidates"][0]["geometry"]["location"]
            return location["lat"], location["lng"]
        else:
            raise ValueError(f"Failed to retrieve coordinates for the place {place} ")

    def calculate_travel_time(self, origin, destination, mode="transit"):
        origin_coordinates = self.get_coordinates(origin)
        destination_coordinates = self.get_coordinates(destination)

        endpoint = "https://maps.googleapis.com/maps/api/directions/json"
        params = {
            "origin": f"{origin_coordinates[0]},{origin_coordinates[1]}",
            "destination": f"{destination_coordinates[0]},{destination_coordinates[1]}",
            "mode": mode,
            "key": self.api_key,
        }

        response = requests.get(endpoint, params=params)
        result = response.json()

        if result["status"] == "OK":
            route = result["routes"][0]
            leg = route["legs"][0]
            travel_time = leg["duration"]["text"]
            return travel_time
        else:
            raise ValueError("Failed to calculate travel time")

    def get_cities_distances(self, cities):
        distances = {}
        city_names = list(cities.keys())
        for combo in itertools.combinations(city_names, 2):
            key = (combo[0], combo[1])
            distances[key] = self.translate_time_to_minutes(
                self.calculate_travel_time(cities[combo[0]], cities[combo[1]])
            )

        return distances

class ActivityScraper_Maker(GoogleMapsTravelTimeCalculator):
    def __init__(self, api_key, cities=None):
        super().__init__(api_key)
        self.cities = cities if cities is not None else {}

    def things_to_do(self, city):
        url = f"https://api.content.tripadvisor.com/api/v1/location/search?key=4098A20E9DC543AEB18B7C720F3D7002&searchQuery={city}&category=attractions&language=en"
        headers = {"accept": "application/json"}

        response = requests.get(url, headers=headers)
        if response.status_code == 200:
            json_data = response.json()
            parsed_data = {item['name']: item['address_obj']['address_string'] for item in json_data['data']}
            return parsed_data
        else:
            print("Error: Unable to fetch data from the API TRIPADVISOR")
            print(response.status_code)

    def tsp(self, starting_city, cities_to_visit, distances):
        tour = [starting_city]
        current_city = starting_city

        while len(cities_to_visit) > 0:
            nearest_city = min(cities_to_visit, key=lambda city: self.calculate_distance(current_city, city, distances))
            tour.append(nearest_city)
            cities_to_visit.remove(nearest_city)
            current_city = nearest_city

        tour.append(starting_city)
        return tour

    def calculate_distance(self, city1, city2, distances):
        return distances.get((city1, city2), float('inf'))

    def optimal_route(self, starting_city):
        cities_to_visit = list(self.cities.keys())
        cities_to_visit.remove(starting_city)
        distances = self.get_cities_distances(self.cities)
        tour = self.tsp(starting_city, cities_to_visit, distances)
        print("Optimal tour:", tour)
        return tour





















