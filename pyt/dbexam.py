import pymongo
print("hello")
# import psycopg2
# con = psycopg2.connect(database="postgres", user="postgres", password="1123581321", host="127.0.0.1", port="5432")
# cur = con.cursor()
# cur.execute('''CREATE TABLE STUDENT
#       (ADMISSION INT PRIMARY KEY     NOT NULL,
#       NAME           TEXT    NOT NULL,
#       AGE            INT     NOT NULL,
#       COURSE        CHAR(50),
#       DEPARTMENT        CHAR(50));''')
# print("Table created successfully")

# con.commit()
# con.close()
# import redis

# redis_client = redis.Redis(charset="utf-8", decode_responses=True)
# redis_client.hset("a","b","c")

myclient = pymongo.MongoClient("mongodb://localhost:27017/")

mydb = myclient["mydatabase"]
