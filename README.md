# ec2spec

[![Gem Version](https://badge.fury.io/rb/ec2spec.svg)](https://badge.fury.io/rb/ec2spec)
[![MIT License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)][license]

[license]: https://github.com/kyoshidajp/ec2spec/blob/master/LICENSE

ec2spec is a simple comparison tool for Amazon EC2 Instances.

## Installation

```
$ gem install ec2spec
```

## Usage

```
$ ec2spec ssh -h host1 host2 host3
```

```
I, [2018-08-12T20:54:25.814752 #64341]  INFO -- : Started: host1
I, [2018-08-12T20:54:25.814835 #64341]  INFO -- : Started: host2
I, [2018-08-12T20:54:25.814867 #64341]  INFO -- : Started: host3
I, [2018-08-12T20:54:25.826113 #64341]  INFO -- : Finished: host3
I, [2018-08-12T20:54:29.385848 #64341]  INFO -- : Finished: host1
I, [2018-08-12T20:54:37.560003 #64341]  INFO -- : Finished: host2
+---------------+-------------+-------------+-------+
|               | host1       | host2       | host3 |
+---------------+-------------+-------------|-------+
| instance_type |    t2.micro |  c4.2xlarge |   N/A |
|   instance_id |  i-xxxxxxxx |  i-yyyyyyyy |   N/A |
|        memory |   1016324kB |  15395932kB |   N/A |
| price (USD/H) |      0.0152 |       0.504 |   N/A |
| price (USD/M) |     11.3088 |     374.976 |   N/A |
+---------------+-------------+---------------------+
```

The data of `host3` could not be acquired due to some error.

## As a library

```
> require 'ec2spec'
> hosts = %w[host1 host2]
> client = Ec2spec::Client.new(hosts, 30, 'hash')
> result_json = client.run
> puts result_json
I, [2018-08-12T20:54:25.814752 #64341]  INFO -- : Started: host1
I, [2018-08-12T20:54:25.814835 #64341]  INFO -- : Started: host2
I, [2018-08-12T20:54:29.385848 #64341]  INFO -- : Finished: host1
I, [2018-08-12T20:54:37.560003 #64341]  INFO -- : Finished: host2
=> {"host1":{"instance_type":"t2.micro","instance_id":"i-xxxxxxxx","memory":"1016324kB","price (USD/H)":0.152,"price (USD/M)":11.3088},"host2":{"instance_type":"c4.2xlarge","instance_id":"i-yyyyyyyy","memory":"15395932kB","price (USD/H)":0.504,"price (USD/M)":374.976}}
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kyoshidajp/ec2spec.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
