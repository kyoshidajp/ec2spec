# ec2spec

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

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kyoshidajp/ec2spec.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
