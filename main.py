import mysql.connector
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates
import os 
import hashlib
import random
import string 
import re
import ast
from fastapi import FastAPI, Response,  Request, HTTPException, Depends, BackgroundTasks, Form
import uvicorn
from cryptography.fernet import Fernet
import smtplib
import dns.resolver
from email.message import EmailMessage
import ssl
from auth import AuthHandler
import csv
import oopmain
import time 
from datetime import datetime, timedelta




def day_difference(date1_str, date2_str):
    date_format = "%d/%m/%Y"
    date1_obj = datetime.strptime(date1_str, date_format)
    date2_obj = datetime.strptime(date2_str, date_format)
    
    difference = date2_obj - date1_obj
    return str((difference.days))





def parse_custom_time(time_str):

    custom_format_match = re.match(r'(\d+) hours? (\d+) mins?', time_str)
    
    if custom_format_match:
        hours, minutes = map(int, custom_format_match.groups())
        return timedelta(hours=hours, minutes=minutes)
   
    elif re.match(r'(\d+) hour', time_str):
        hours = int(re.match(r'(\d+) hour', time_str).group(1))
        return timedelta(hours=hours)
    
    elif re.match(r'(\d+) min', time_str):
        minutes = int(re.match(r'(\d+) min', time_str).group(1))
        return timedelta(minutes=minutes)
 

    else:
        return timedelta(hours=int(time_str[:2]), minutes=int(time_str[-2:]))


    
def add_time(time_str1, time_str2):
    time1 = parse_custom_time(time_str1)
    time2 = parse_custom_time(time_str2)
    result_time = datetime(1900, 1, 1) + (time1 + time2)
    result_time_str = result_time.strftime("%H:%M")
    return result_time_str


def subtract_time(time_str1, time_str2):
    time1 = parse_custom_time(time_str1)
    time2 = parse_custom_time(time_str2)
    result_time = datetime(1900, 1, 1) + (time1 - time2)
    result_time_str = result_time.strftime("%H:%M")

    return result_time_str



auth_handler=AuthHandler()









def connect_to_database():
    # Establish the connection
    Fast_Track_db = mysql.connector.connect(
        host="192.168.1.136",
        user="admin_hysam",
        password="Sohybe098!",
        database="FAST_TRACK"
    )
    return Fast_Track_db

def close_database_connection(connection):
    # Close the connection
    connection.close()


def show_triggers(table_name):
    try:
        connection = mysql.connector.connect(
            host="192.168.1.136",
        user="admin_hysam",
        password="Sohybe098!",
        database="FAST_TRACK"
    )
        if connection.is_connected():
            cursor = connection.cursor()
            cursor.execute("SHOW TRIGGERS WHERE `Table` = %s", (table_name,))
            triggers = cursor.fetchall()
            return triggers
    except mysql.connector.Error as e:
        print("Error connecting to MySQL:", e)
    finally:
        if connection and connection.is_connected():
            cursor.close()
            connection.close()










def verify_email_auth(email):
    verification_code=random.randint(100000, 999999)
    email_sender='rrahman.hr@gmail.com'
    email_passwords='xfbb ckow npdi ylah'
    email_receiver=email
    subject='Verification Code For FAST TRACK APP'
    body=f'''
Dear User, 




Your Verification Code Is {verification_code} 



Regards,
FAST TRACK APP Team.
'''
    em=EmailMessage()
    em['From']=email_sender
    em['To']=email_receiver
    em['Subject']=subject
    em.set_content(body)
    context=ssl.create_default_context()
    with smtplib.SMTP_SSL('smtp.gmail.com', 465, context=context) as smtp:
        smtp.login(email_sender, email_passwords)
        smtp.sendmail(email_sender, email_receiver, em.as_string())
    return str(verification_code)


def write_to_db(table, values, things_to_write):
    Fast_Track_db = connect_to_database()
    try:
        with Fast_Track_db.cursor() as mycursor:
            placeholders = ', '.join(['%s'] * len(things_to_write))
            sql = f"INSERT INTO {table} ({', '.join(values)}) VALUES ({placeholders})"
            mycursor.execute(sql, things_to_write)
            Fast_Track_db.commit()

            return f"Successfully committed {things_to_write} into {table}"
    except Exception as e:
        print('Exception occurred while executing SQL statement:', e)
        print('SQL STATEMENT:', sql)
        Fast_Track_db.rollback()
        return "Unsuccessful"
    finally:
        close_database_connection(Fast_Track_db)
    
def update_column(table, column_to_update, new_value, condition):
    try:
        Fast_Track_db = connect_to_database()
        with Fast_Track_db.cursor() as cursor:
            sql = f"UPDATE {table} SET {column_to_update} = %s WHERE {condition}"
            cursor.execute(sql, (new_value,))
            Fast_Track_db.commit()

            return f"Successfully updated {column_to_update} in {table}"
    except Exception as e:
        print('Exception occurred while executing SQL statement:', e)
        print('SQL STATEMENT:', sql)
        Fast_Track_db.rollback()
        return "Unsuccessful"
    finally:
        close_database_connection(Fast_Track_db)



def delete_from_db(table, condition):
    Fast_Track_db = connect_to_database()
    try:
        with Fast_Track_db.cursor() as mycursor:
            sql = f"DELETE FROM {table} WHERE {condition}"
            mycursor.execute(sql)
            Fast_Track_db.commit()
            return f"Successfully deleted records from {table} where {condition}"
    except Exception as e:
        print('Exception occurred while executing SQL statement:', e)
        print('SQL STATEMENT:', sql)
        Fast_Track_db.rollback()
        return "Unsuccessful"
    finally:
        close_database_connection(Fast_Track_db)






def retrieve_from_db(table, columns, conditions, condition_values):
    Fast_Track_db = connect_to_database()
    try:
        with Fast_Track_db.cursor() as mycursor:
            column_list = ', '.join(columns)
            condition_string = ' AND '.join([f"{col} = %s" for col in conditions])
            sql = f"SELECT {column_list} FROM {table} WHERE {condition_string}"
            mycursor.execute(sql, condition_values)
            result = mycursor.fetchall()
            if result:
                return str(result[0][0])  # Assuming you want to return the first column of the first row as a string
            else:
                return False
    except Exception as e:
        print('Exception occurred while executing SQL statement:', e)
        print('SQL STATEMENT:', sql)
        return False
    finally:
        close_database_connection(Fast_Track_db)



def retrieve_from_db_multiple(table, columns, conditions, condition_values):
    Fast_Track_db = connect_to_database()
    try:
        with Fast_Track_db.cursor() as mycursor:
            column_list = ', '.join(columns)
            condition_string = ' AND '.join([f"{col} = %s" for col in conditions])
            sql = f"SELECT {column_list} FROM {table} WHERE {condition_string}"
            mycursor.execute(sql, condition_values)
            result = mycursor.fetchall()
            if result:
                return list(result)
            else:
                return False
    except Exception as e:
        print('Exception occurred while executing SQL statement:', e)
        print('SQL STATEMENT:', sql)
        return False
    finally:
        close_database_connection(Fast_Track_db)

    

def retrieve_from_db_multiple_temp(table, columns, conditions, condition_values):
    Fast_Track_db = connect_to_database()
    try:
        with Fast_Track_db.cursor() as mycursor:
            column_list = ', '.join(columns)
            condition_string = ' AND '.join([f"{col} = %s" for col in conditions])
            sql = f"SELECT {column_list} FROM {table} WHERE {condition_string}"
            mycursor.execute(sql, condition_values)
            result = mycursor.fetchall()
            if result:
                print('RESULT:::::', result)

                return (result)
            else:
                return False
    except Exception as e:
        print('Exception occurred while executing SQL statement:', e)
        print('SQL STATEMENT:', sql)
        return False
    finally:
        close_database_connection(Fast_Track_db)




def dashboard_info(user):
    
    user_id=retrieve_from_db('User_Credentials', ['User_Id'],['Email_address'], [user] )
    trips=retrieve_from_db_multiple('Parent_Activity', ['Parent_Activity_Id'], ['User_Id'], [user_id])
        #select Parent_Activity_Id from Parent_Activity where User_Id='9h]=f@ig03m';
    active_trips=[]
    for i in trips:
        x=re.sub(r'[^a-zA-Z0-9 ]', '', str(i))
        temp=retrieve_from_db_multiple('Parent_Activity_Status', ['Parent_Activity_Id','Active'], ['Parent_Activity_Id'], [x])
        for items in temp:
            clean_format=re.sub(r'[^a-zA-Z0-9 ]', '', str(items))
            if clean_format[-1]=='y':
                active_trips.append(clean_format[:-2])
    
    print('hello 123')
    print(active_trips)
    return active_trips


def detail_dashboard_info(user):
    tripinfo=[]
    ids=dashboard_info(user)
    for id in ids:

        
        temp=retrieve_from_db_multiple('Parent_Activity_Details', ['Parent_Activity_Id', 'Parent_Activity_Location', 'Origin', 'Fly_Out_Date', 'Fly_Back_Date'],['Parent_Activity_Id'], [id])
        tripinfo.append(temp)
    print(tripinfo)
    return tripinfo


def hash_password_with_salt_and_pepper(password,):


    salt = os.urandom(16) 
    pepper = os.urandom(16)  


    salted_peppered_password = pepper + salt + password.encode('utf-8')
    hashed_password = hashlib.sha256(salted_peppered_password).hexdigest()
    return f"{salt.hex()}:{pepper.hex()}:{hashed_password}"

def check_does_not_already_exist(table, column, to_check):
    Fast_Track_db = connect_to_database()
    try:
        with Fast_Track_db.cursor() as mycursor:
            sql = f"SELECT {column} FROM {table} WHERE {column} = %s"
            mycursor.execute(sql, (to_check,))
            results = mycursor.fetchall()
            if results:
                return False  # Already exists
            else:
                return True  # Does not exist already, proceed
    except Exception as e:
        print('Exception occurred while executing SQL statement:', e)
        print('SQL STATEMENT:', sql)
        return "Error Occurred"
    finally:
        close_database_connection(Fast_Track_db)


def credential_maker():
    finished=False
    while not finished:
        characters = string.ascii_letters + string.digits
        random_string_list=[]
        for i in range (0,12):
            random_charecter=random.choice(characters)
            random_string_list.append(random_charecter)
        
        user_credentials_id=''.join(random_string_list)

        if check_does_not_already_exist('User_Credentials','User_Id', user_credentials_id ):
            finished=True
            return user_credentials_id
    
        
def store_10k():
    with open ("/Users/hysam/Desktop/FAST TRACK APP/Fast_track_APIs/LOGIN_SIGNUP/SignUp/10kasswords.txt", "r") as file :
        lines= file.readlines()

    return lines


def bubble_sort(my_list):
  

    list_length = len(my_list)

    while True:
        nothing_swapped = True

        for index in range(list_length - 1):
            item1 = my_list[index]
            item2 = my_list[index + 1]

           
            if isinstance(item1, str) and isinstance(item2, str):  
                if item1 > item2: 
                    my_list[index], my_list[index + 1] = item2, item1
                    nothing_swapped = False
            elif isinstance(item1, (int, float)) and isinstance(item2, (int, float)): 
                if item1 > item2:  
                    my_list[index], my_list[index + 1] = item2, item1
                    nothing_swapped = False
            

        if nothing_swapped:
            break 
    return my_list


def binary_search(items, target):
    min_index = 0
    max_index = len(items) - 1
    while min_index <= max_index:
        mid_index = (min_index + max_index) // 2
        if isinstance(target, str):
            if isinstance(items[mid_index], str):
                if target.lower() in items[mid_index].lower():
                    return True
                elif target.lower() < items[mid_index].lower():
                    max_index = mid_index - 1
                else:
                    min_index = mid_index + 1
            else:
                return False
        else:
            if target == items[mid_index]:
                return True
            elif target < items[mid_index]:
                max_index = mid_index - 1
            else:
                min_index = mid_index + 1
    return False



def check_consequitivenumbers(numericpasswrd): 
    num = re.findall(r'\d+', numericpasswrd)
    
    counter = 0
    

    for numbers in num:
        length = len(numbers)
        if length >= 3:
            for i in range(length-1):
                first_digit = numbers[i]
                second_digit = numbers[i + 1]
                if int(second_digit) - int(first_digit) == 1 :
                    counter += 1
                elif int(second_digit)-int(first_digit)==0:
                    counter += 1
    if counter >= 2:
        return True


def format_password(password):
    return re.sub(r'[^a-zA-Z]', '', password)


            
def check_password_is_strong(password):
    if len(password) < 8:
        return False
    if not re.search(r'\d', password):
        return False
    if not re.search(r'[A-Z]', password):
        return False
    if not re.search(r'[a-z]', password):
        return False
    if not re.search(r'[^\w]', password):
        return False
    if binary_search(store_10k(), format_password(password))==True:
        return False
    if check_consequitivenumbers(password)==True :
        return False
    return True



def sign_up(email, password, name1, name2, homeBase, age, family, solo, friends, ki1, ki2, ki3):
    user_id = credential_maker()
    if check_does_not_already_exist('User_login', 'Email_address', email):
        if check_password_is_strong(password):
            try:
                a=write_to_db('User_login', ['Email_address', 'hashed_password'], [email, hash_password_with_salt_and_pepper(password)])
                b=write_to_db('User_Credentials', ['User_Id', 'Email_address'], [user_id, email])
                c=write_to_db('User_Details', ['User_Id', 'First_Name', 'Second_Name', 'Home_base'], [user_id, name1, name2, homeBase])
                d=write_to_db('User_Interest', ['User_Id', 'Age_Band', 'Family', 'Solo', 'Friends', 'Key_interest_1', 'Key_interest_2', 'Key_interest_3'], [user_id, age, family, solo, friends, ki1, ki2, ki3])
                return "User successfully signed up"
            except Exception as e:
                print(e)
                return "Unsuccessful"
        else:
            return("password too weak")
    else:
        return("email already exist ")
    
def add_city(city,user, origin, departure, returndate):
    pid=credential_maker()
    user_id=retrieve_from_db('User_Credentials', ['User_Id'],['Email_address'], [user] )
    write_to_db('Parent_Activity', ['Parent_Activity_Id', 'User_Id', 'Acess_Rights'], [pid, user_id, 'a'])
    write_to_db('Parent_Activity_Status', ['Parent_Activity_Id', 'Activity_Status', 'Active'], [pid, 'a', 'y'])
    write_to_db('Parent_Activity_Details', ['Parent_Activity_Id', 'Parent_Activity_Location', 'Origin', 'Holiday_Type', 'Fly_Out_Date', 'Fly_Back_Date'], [pid, city, origin, 'a', departure, returndate])
    return pid


def add_hotel(hotel, Parent_Activity_Id, airportname, arrivaltime, departuretime, arrivaldate, departuredate, hoteltransfertime, hoteltrasnfer2, checkout   ):
    pid1=credential_maker()
    pid2=credential_maker()
    pid3=credential_maker()
    pid4=credential_maker()


    temp2=add_time(hoteltrasnfer2, '03:00')
    timetogo=subtract_time(departuretime, temp2)


    
    land_at_airport=write_to_db('Child_Activity',['Child_Activity_Id', 'Parent_Activity_Id', 'Date', 'Time_Start', 'Time_Finish', 'Origin', 'Location', 'Details'], [pid1, Parent_Activity_Id, arrivaldate, (subtract_time(arrivaltime,'00:30')), arrivaltime, airportname,  airportname, f'Land at {airportname}' ])
    print('land at airport added')
    Journey_To_Hotel=write_to_db('Child_Activity',['Child_Activity_Id', 'Parent_Activity_Id', 'Date', 'Time_Start', 'Time_Finish', 'Origin', 'Location', 'Details'], [pid2, Parent_Activity_Id, arrivaldate, (add_time(arrivaltime,'02:00')), (add_time(hoteltransfertime,  (add_time(arrivaltime,'02:00'))  )), airportname,  hotel, f'Journey to hotel' ])
    print('journey to hotel passed')
    checkout_of_hotel=write_to_db('Child_Activity',['Child_Activity_Id', 'Parent_Activity_Id', 'Date', 'Time_Start', 'Time_Finish','Origin', 'Location', 'Details'], [pid4, Parent_Activity_Id, departuredate, (subtract_time(checkout,'01:30')), checkout, hotel,  hotel, f'Get ready and checkout of your hotel' ])
    print('checkout added ')    
    Journey_To_Airport=write_to_db('Child_Activity',['Child_Activity_Id', 'Parent_Activity_Id', 'Date', 'Time_Start', 'Time_Finish','Origin', 'Location', 'Details'], [pid3, Parent_Activity_Id, departuredate, timetogo, add_time(timetogo, hoteltrasnfer2), hotel,  airportname, f'Journey to Airport' ])
    print('hourney to airport added ')
    return [pid1, pid2, pid3]



    


    

def verify_password(input_password, stored_password):

    salt_hex, pepper_hex, stored_hashed_password = stored_password.split(':')
    salt = bytes.fromhex(salt_hex)
    pepper = bytes.fromhex(pepper_hex)


    input_password_combined = pepper + salt + input_password.encode('utf-8')
    input_hashed_password = hashlib.sha256(input_password_combined).hexdigest()

    if input_hashed_password == stored_hashed_password:
        return True
    else:
        return False 

def login(usernmae, password):

    if check_does_not_already_exist('User_login', 'Email_address', usernmae):
        return('username false')
    else:
        password_retrieved=  retrieve_from_db('User_login', ['hashed_password'], ['Email_address'], [usernmae])
        if len(password_retrieved) > 0:
            if verify_password(password, password_retrieved):
                return True
            else:
                return False
        else:
            return('an error occured')





def v_email(email):


    
    fromAddress = 'corn@bt.com'


    regex = '^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,})$'



    addressToVerify = email
    try:
        match = re.match(regex, addressToVerify)
    except:
        pass 

    if match == None:
        return False

    splitAddress = addressToVerify.split('@')
    domain = str(splitAddress[1])

    records = dns.resolver.query(domain, 'MX')
    mxRecord = records[0].exchange
    mxRecord = str(mxRecord)



    server = smtplib.SMTP()
    server.set_debuglevel(0)

    # SMTP Conversation
    server.connect(mxRecord)
    server.helo(server.local_hostname) 
    server.mail(fromAddress)
    code, message = server.rcpt(str(addressToVerify))
    server.quit()

    #print(code)
    #print(message)


    if code == 250:
        
        return True
    else:
        return False
        #print(code)
        #print(message)



def encrypt_fernet(text):
    key_fernet = b'c1563NcXz90uGYpMqpfm_k10rOLVF5Q37AY6D016n_4='
    fernet = Fernet(key_fernet)
    encrypted = fernet.encrypt(text.encode())
    return encrypted

def decrypt_fernet(text):
    key_fernet = b'c1563NcXz90uGYpMqpfm_k10rOLVF5Q37AY6D016n_4='
    fernet = Fernet(key_fernet)
    decrypted = fernet.decrypt(text.encode())
    return decrypted.decode()



class Time_table():

    def add_one_day(self, date_str):
        date_obj = datetime.strptime(date_str, "%d/%m/%Y")
        new_date = date_obj + timedelta(days=1)
        return new_date.strftime("%d/%m/%Y")


    def divide_list_into_sublists(self, lst, num_sublists):
        sublist_length = len(lst) // num_sublists
        remaining_elements = len(lst) % num_sublists
        start = 0
        sublists = []
        for i in range(num_sublists):
            end = start + sublist_length + (1 if i < remaining_elements else 0)
            sublists.append(lst[start:end])
            start = end
        return sublists



    def add_activity_to_db(self, pa_id, optimal_route, start_day, num_day):
        
        
        
        
        
        activities_per_day=(num_day-2)
        temp_lst=optimal_route[1:len(optimal_route)-1]
        activities_divided=self.divide_list_into_sublists(temp_lst, activities_per_day)



        for i in range(num_day-1):
            try:
                start_day = self.add_one_day(start_day)
                to_add_day = activities_divided[i]
                for j in to_add_day:
                    pid = credential_maker()
                    write_to_db('Child_Activity', ['Child_Activity_Id', 'Parent_Activity_Id', 'Date', 'Time_Start', 'Time_Finish', 'Origin', 'Location', 'Details'], [pid, pa_id, start_day, '00:00', '00:00', 'origin',  j, f'Visit {j}' ])
                    print(f'wrote to db {pid, start_day, j}')
           
            except Exception as e:  # Catching all exceptions
               
                print(f'failed at {pid}, {i}')
                print(f"An error occurred: {e}")
        return True 
    
    def retrv_plan(self, paidd):
        temp=retrieve_from_db_multiple('Child_Activity', ['Date', 'Location'], ['Parent_Activity_Id'],[paidd])
        return temp 







def update_single_task(pa_id: str, date: str, item: str):
    print("Executing update_single_task")
    try:
        pid = credential_maker()
        write_to_db('Child_Activity', ['Child_Activity_Id', 'Parent_Activity_Id', 'Date', 'Time_Start', 'Time_Finish', 'Origin', 'Location', 'Details'], [pid, pa_id, date, '00:00', '00:00', 'origin', item, f'Visit {item}'])
        print('Activity added successfully:', pid)
    except Exception as e:
        print('Error occurred while updating activity:', e)



def delete_elements_task(pa_id: str):
    try:
        print('Deleting activities for Parent Activity ID:', pa_id)
        result = delete_from_db('Child_Activity', f"Parent_Activity_Id='{pa_id}'")
        print('Deletion result:', result)
    except Exception as e:
        print('Error occurred while deleting activities:', e)










app = FastAPI()













@app.get("/login")
def login_api(username, password):
    email=decrypt_fernet(str(username), )
    psswrd=decrypt_fernet(str(password), )
    if login(email, psswrd) == True:
        return (f'true,{auth_handler.encode_token(email)}')
    else:
        return login(email, password)



@app.get('/email_send_code')
def email_verify(enc_email):
    email=decrypt_fernet(enc_email)
    code=verify_email_auth(email)
    return encrypt_fernet(code)


@app.get('/email_reset')
def email_verify(email):
    return int(verify_email_auth(email))


@app.get('/reset_password')
def reset(email, password):
    if check_password_is_strong(password):
        update_column('User_login','hashed_password', hash_password_with_salt_and_pepper(password), f"Email_address='{email}'" )
    else:
        return False



@app.get('/signup')
def signup_api(email, password, name1='n', name2='n', homeBase='n', age='n', family='n', solo='n', friends='n', interests=['n', 'n', 'n']):


    ki1=interests[0]
    ki2=interests[1]
    ki3=interests[2]

    emailaddr=decrypt_fernet(email)
    psswrd=decrypt_fernet(password)
    if sign_up(emailaddr, psswrd, name1, name2, homeBase, age, family, solo, friends, ki1, ki2, ki3):
        return (f'true,{auth_handler.encode_token(emailaddr)}')
    else:
        return False
    

@app.get('/verify')
def verify(enc_email, enc_password):
    print('Works!')


    email=decrypt_fernet(enc_email)
    print(email)
    password=decrypt_fernet(enc_password)







    print(f' CHECK ::: {check_does_not_already_exist('User_login', 'Email_address', email)}' )
    if check_does_not_already_exist('User_login', 'Email_address', email):
        if v_email(email):


            if check_password_is_strong(password):
                return True
            
            else:
                return 'password weak'

        else:
            return False    


    else:
        return "email in use"



@app.get('/test')
def test(x=Depends(auth_handler.auth_wrapper)):
    return x
  

@app.get('/dashboard_info')
def dashboard_info_api(username=Depends(auth_handler.auth_wrapper)):
    try:
        x=detail_dashboard_info(username)
        return x
    except:
        return ['error in api callback']
    



@app.get('/flight_info')
def get_flight_info(  fnum, date, ):
    try:
        instance=oopmain.Flight(int(fnum[2:]), fnum[0:2], date)
        return instance.get_initial_info()
    except Exception as e:
        print(e)
        return 'Error while fetching- enter detail properly'

@app.get('/add_parent_activity')
def add_parent_activity(location, origin, dep, ret, username=Depends(auth_handler.auth_wrapper)):
    try:
          return add_city(location, username, origin, dep, ret)
          
    except Exception as e:
        print(e)
        return False
    
@app.get('/add_hotel')
def add_hotel_db(hotel, Parent_Activity_Id, airportname, arrivaltime, departuretime, arrivaldate, departuredate,  checkout, user=Depends(auth_handler.auth_wrapper)):
    try:
        api_key = "AIzaSyCIwodz3NUBEQIs0ToIyRB7yI_KdxF8VS4"
        google_maps_calculator = oopmain.GoogleMapsTravelTimeCalculator(api_key)
        return add_hotel(hotel, Parent_Activity_Id, airportname, arrivaltime, departuretime, arrivaldate, departuredate, google_maps_calculator.calculate_travel_time(airportname, hotel), google_maps_calculator.calculate_travel_time(hotel, airportname), checkout)
    
    except Exception as e:
        print(e)
        return False
    

@app.get('/attractions')
def attractions(city,username=Depends(auth_handler.auth_wrapper)):
    instance=oopmain.ActivityScraper_Maker('AIzaSyCIwodz3NUBEQIs0ToIyRB7yI_KdxF8VS4')
    return instance.things_to_do(city)





@app.get('/routine_lookup')
def routine(paid, ):
    routine_instance = Time_table()
    print('PAID:' + paid)
    result = routine_instance.retrv_plan(paid)
    print(result)
    return result



@app.get('/update_db_ca')


def update_db_ca(poi_key: str, pa_id: str, user=Depends(auth_handler.auth_wrapper)):
    # Correcting the format of the string representation of the set
    poi_key_corrected = poi_key.replace('{', "{'").replace(',', "', '").replace('}', "'}")
    
    # Convert the corrected string representation of the set into a proper set
    set_values = ast.literal_eval(poi_key_corrected)
    
    # Create a dictionary where both keys and values are the same
    poi = {elem: elem for elem in set_values}
    
    # Print for debugging
    print(poi_key)
    print(type(poi_key))
    print(poi)

    







    hotel_temp=retrieve_from_db('Child_Activity', ['Location'], ['Parent_Activity_Id', 'Details'], [pa_id, 'Journey to hotel'])
    poi[hotel_temp]=hotel_temp
    
    
    
    
    start_day_temp=retrieve_from_db('Child_Activity', ['Date'], ['Parent_Activity_Id', 'Details'], [pa_id, 'Journey to hotel'])
    end_day_temp=retrieve_from_db('Child_Activity', ['Date'], ['Parent_Activity_Id', 'Details'], [pa_id, 'Journey to Airport'])
    
    day_diff=abs(int(day_difference(start_day_temp, end_day_temp)))
    



    optimal_instance=oopmain.ActivityScraper_Maker('AIzaSyCIwodz3NUBEQIs0ToIyRB7yI_KdxF8VS4', poi)
    time_table_instance=Time_table()
    tsp=optimal_instance.optimal_route(hotel_temp)
    print('hello123')
    time_table_instance.add_activity_to_db(pa_id, tsp, start_day_temp, day_diff)
    print('done')
    return 'True'












# Update the update_single function to use BackgroundTasks
@app.get('/update_single')
async def update_single(pa_id: str, date: str, item: str, background_tasks: BackgroundTasks):
    time.sleep(1)
    background_tasks.add_task(update_single_task, pa_id, date, item)
    return {"message": "Activity update request received and is being processed in the background."}


@app.get('/delete_elemetns')
async def delete_elements(pa_id: str, background_tasks: BackgroundTasks):
    time.sleep(1)
    background_tasks.add_task(delete_elements_task, pa_id)
    return {"message": "Delete activity request received and is being processed in the background."}










@app.get('/share_db')
def share_db(email, pa_id, ):
    user_id=retrieve_from_db('User_Credentials', ['User_Id'],['Email_address'],[email])
    if user_id!=False:
        if  write_to_db('Parent_Activity', ['Parent_Activity_Id','User_Id', 'Acess_Rights' ], [pa_id, user_id, 's']) != 'Unsuccessful':
            return True
    else:
        return False

@app.get('/delte_share')
def delete_share(email, pa_id, ):
    user_id=retrieve_from_db('User_Credentials', ['User_Id'],['Email_address'],[email])
    return delete_from_db('Parent_Activity', f"Parent_Activity_Id='{pa_id}' AND User_Id='{user_id}' AND Acess_Rights='s' ")


@app.get('/delete_trip')
def delete_trip(pa_id):
    update_column('Parent_Activity_Status', 'Active', 'x', f"Parent_Activity_Id='{pa_id}'")
    update_column('Parent_Activity_Status', 'Fly_Out_Date', '01/01/2018', f"Parent_Activity_Id='{pa_id}'")
    update_column('Parent_Activity_Details', 'Flay_Back_Date', '01/01/2018', f"Parent_Activity_Id='{pa_id}'")


@app.get('/display_shares')
def diplay_shares(paid, ):
    emails=[]
    user_ids=retrieve_from_db_multiple_temp('Parent_Activity', ['User_Id'], ['Parent_Activity_Id','Acess_Rights' ],[paid,'s' ])
    
    print(user_ids)
    print('hello')
    if user_ids!=False:
        normal_list = [item[0] for item in user_ids]
        
        for i in normal_list:
            emails.append(retrieve_from_db('User_Credentials', ['Email_address'],['User_ID'],[i]))
    
    return emails





#delete_trip('IwPKmA6W9OXc')



if __name__ == "__main__":
        ssl_keyfile = "/Users/hysam/key.pem"
        ssl_certfile = "/Users/hysam/cert.pem"

        uvicorn.run("main:app", host="127.0.0.1", port=8000, ssl_keyfile=ssl_keyfile, ssl_certfile=ssl_certfile) 








    
# print(verify('gAAAAABlhZ1eCzn_gZ3dozWVxEQs8nITpiYQLaxs99Wyoce8IrCM82XaQglpkh4tdIvQSzrS9F3usf93DsBU4f-CAeQRdN42FQ==','gAAAAABlhZ1e9ONVazsvsv9z3JxrN5vy5bcvGtg7CzOzOIV25NBuf07kaee-CsJsLRiUh7E7iwBvPoGnlrqFjMrS7g9eAXBR_g==' ))
    

#retrieve_from_db('User_login', ['hashed_password'], ['Email_address'], ['rrahman.hr@gmail.com'])



