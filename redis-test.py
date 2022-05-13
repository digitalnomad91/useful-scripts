import redis
import random
import time

r = redis.StrictRedis(host='localhost', port=6379, db=0)


def write_to_redis_million_times():

    for i in range(1000000):
        ramdom_int_list = random.sample(range(len(range(100))), 10)
        r.set('post_{}'.format(i), ramdom_int_list)


start_time = time.time()
write_to_redis_million_times()
end_time = time.time()


print("time it look to complete a million writes to redis %0.2fs" % (end_time - start_time))



for i in range(100):
    print(r.get('post_{}'.format(i)))
