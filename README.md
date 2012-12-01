# Lockstep - Coordinating value changes across computers cheaply and predicatbly

[![Build Status][travis-image]][travis-link] 
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/nullstyle/lockstep)

[travis-image]: https://secure.travis-ci.org/nullstyle/lockstep.png?branch=master
[travis-link]: https://travis-ci.org/nullstyle/lockstep
[travis-home]: http://travis-ci.org/


_NOTE: this is still being developed.  it doesn't do shit right now.  but hey, the specs pass_

Let's describe a situation.  You run a website that serves a crazy amount of traffic: Over a billion dynamic requests per day.  That's nearly 12,000 requests per second.  Let's now assume you have a piece of data that you want to access on _every_ request. You also want to be reasonably sure that every server you have sees the same value of that data at a given point in time.  Normally, you have a couple of options to how you can store this data:

1.  In your source code:  define a constant value and simply access the in memory value.  The drawback here is that to change this value you need to deploy your application.  This is best used for values that change very infrequently.  This solution is infinitely scaleable, but inflexible.
1.  In a database: read from the database on every request.  The drawback here is that we are referring to shared storage which might not scale well enough to keep up.  You can always invest in a distributed db that's scales up, that might be complicated to manage, and not worth the cost.  This solution is best used for values that may change frequently and/or provide high value to the application to justify the cost.  This solution is very flexible, but costly.

Lockstep provides a tradeoff in the middle of cost/flexibility.  It provides a reasonable flexibility by allowing you to use a database to store the value, but allows you to choose a level of scaleability appropriate to how often the value will change.  The more often the value needs to change, the more traffic you database will see.

Let's use a concrete example:  Your application is set to launch a new feature called "foobar" that you aren't sure can withstand the load of your mighty traffic.  You want to do a dark launch (facebook style) to see where you infrastructure starts to fail by gradually turning up the percentage of traffic that triggers this feature.  It wouldn't make sense to read the "percentage active for foobar" from a database, since the load caused by simply reading that value would be significant and effect your results.  Instead, we decide to use a lockstep variable with a tick time of 10 minutes.

Lockstep achieves this by quantizing the times at which a value can change and by storing the timestamp at what time a given value will be made active.  Quantization happens by specifying a tick step.

## Features

- Low cost: A lockstep variable will generate 1 db call per tick per process, and an additional db call when a process boots up
- Scheduled changes:  since we store the time at which a value is made active, we can schedule changes beyond just "the next tick"
- Coordinated: A lockstep variable will change in realtively coordinated fashion on every process in the cluster
- Simple: not need to install hbase or another complicated distributed database.  Lockstep will most likely work with your existing infrastructure (redis, activerecord)


## Assumptions

In regards to your servers:
- You have reasonably in sync clocks.  The jitter across your cluster will be the amount of time that a value could be reported as two different values on separate nodes.  This gem is not appropriate for information that absolutely cannot be out of sync at any time across nodes.

## Contributors

- Scott Fleckenstein

## Contributing

[Fork the project](https://github.com/nullstyle/lockstep) and send pull
requests.


