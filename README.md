# [![](https://user-images.githubusercontent.com/3317191/44626545-42a39380-a959-11e8-96a4-de3b0ea3e96f.png)](https://github.com/kyoshidajp/ec2spec)

[![Gem Version](https://badge.fury.io/rb/ec2spec.svg)](https://badge.fury.io/rb/ec2spec)
[![Build Status](https://travis-ci.org/kyoshidajp/ec2spec.svg?branch=master)](https://travis-ci.org/kyoshidajp/ec2spec)
[![MIT License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)][license]

[license]: https://github.com/kyoshidajp/ec2spec/blob/master/LICENSE

ec2spec is a simple comparison tool for Amazon EC2 Instances you can access.

Supports the following items.

| item     | from    |
| :------- | :------ |
| instance type | host |
| instance id | host |
| vCPU | AWS Price List API |
| memory | AWS Price List API |
| price | AWS Price List API |

The target host must be accessible from the machine. Also, only On-Demand way and Linux machine.

## Installation

```
$ gem install ec2spec
```

## Usage

```
$ ec2spec ssh -h host1 ... [options]
```

### Example

```
$ ec2spec ssh -h host1 host2 host3 --rate 111 --unit JPY
I, [2018-08-12T20:54:25.814752 #64341]  INFO -- : Started: host1
I, [2018-08-12T20:54:25.814835 #64341]  INFO -- : Started: host2
I, [2018-08-12T20:54:25.814867 #64341]  INFO -- : Started: host3
E, [2018-08-12T20:54:25.826113 #64341] ERROR -- : Connection refused: host3
I, [2018-08-12T20:54:29.385848 #64341]  INFO -- : Finished: host1
I, [2018-08-12T20:54:37.560003 #64341]  INFO -- : Finished: host2
+---------------+-------------+---------------------+-------+
|               | host1       | host2               | host3 |
+---------------+-------------+---------------------|-------+
| instance_type |    t2.micro |          c4.2xlarge |   N/A |
|   instance_id |  i-xxxxxxxx |          i-yyyyyyyy |   N/A |
|          vCPU |           1 |                   8 |   N/A |
|        memory |       1 GiB |              15 GiB |   N/A |
| price (USD/H) |      0.0152 |               0.504 |   N/A |
| price (USD/M) |     11.3088 |             374.976 |   N/A |
| price (JPY/H) |      1.6872 |              55.944 |   N/A |
| price (JPY/M) |   1255.2768 |  41622.335999999996 |   N/A |
+---------------+-------------+---------------------+-------+
```

The data of `host3` could not be acquired due to a connection refused error.

### Options

```
-h, --host    Target hosts name.

--days        How many days per one month.

--format      Output format (default: plain_text).
              plain_text, json, hash, slack, markdown

--region      Region of EC2 (default: ap-northeast-1).

--unit        Currency unit.
              with --rate.

--rate        Dollar exchange rate.
              with --unit.
              
--calc_type   Calculate exchange currency rate type.
              api, manual
              with --app_id, --unit (if app)
                   --unit, rate (if manual)

--app_id      App ID of Open Exchange Rates
              https://openexchangerates.org/
              with --calc_type, --unit

--debug       Output logs as DEBUG level.
```

#### --format (`plain_text`)

```
+---------------+-------------+-------------+
|               | host1       | host2       |
+---------------+-------------+-------------|
| instance_type |    t2.micro |  c4.2xlarge |
|   instance_id |  i-xxxxxxxx |  i-yyyyyyyy |
|          vCPU |           1 |           8 |
|        memory |       1 GiB |      15 GiB |
| price (USD/H) |      0.0152 |       0.504 |
| price (USD/M) |     11.3088 |     374.976 |
+---------------+-------------+-------------+
```

#### --format (`json` and `hash`)

```
{"host1":{"instance_type":"t2.micro","instance_id":"i-xxxxxxxx","vCPU":"1","memory":"1 GiB","price (USD/H)":0.0152,"price (USD/M)":11.3088},"host2":{"instance_type":"c4.2xlarge","instance_id":"i-yyyyyyyy","vCPU":"8","memory":"15 GiB","price (USD/H)":0.504,"price (USD/M)":374.976}}
```

#### --format (`slack`)

````
```
+---------------+-------------+-------------+
|               | host1       | host2       |
+---------------+-------------+-------------+
| instance_type |    t2.micro |  c4.2xlarge |
|   instance_id |  i-xxxxxxxx |  i-yyyyyyyy |
|          vCPU |           1 |           8 |
|        memory |       1 GiB |      15 GiB |
| price (USD/H) |      0.0152 |       0.504 |
| price (USD/M) |     11.3088 |     374.976 |
+---------------+-------------+-------------+
```
````

#### --format (`markdown`)

```
|               | stg-bastion | worker1     |
|---------------|-------------|-------------|
| instance_type |    t2.micro |  c4.2xlarge |
|   instance_id |  i-xxxxxxxx |  i-yyyyyyyy |
|          vCPU |           1 |           8 |
|        memory |       1 GiB |      15 GiB |
| price (USD/H) |      0.0152 |       0.504 |
| price (USD/M) |     11.3088 |     374.976 |
```

### Exchange currency rate

#### Manual

Output JPY as exchange rate is 1 dollar 111 yen.

```
$ ec2spec ssh -h host1 host2 --unit JPY --calc_type manual
```

#### API

First, get App ID from
https://openexchangerates.org/

Output JPY with it.

```
$ ec2spec ssh -h host1 host2 --unit JPY --calc_type api --app_id xxxxxxxx
```

**Note:** Exchange rate is cached in `~/.ec2spec/oxr.json`. If you want to refresh, you have to delete it.

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
=> {"host1":{"instance_type":"t2.micro","instance_id":"i-xxxxxxxx","vCPU":"1","memory":"1 GiB","price (USD/H)":0.152,"price (USD/M)":11.3088},"host2":{"instance_type":"c4.2xlarge","instance_id":"i-yyyyyyyy","vCPU":"8","memory":"15 GiB","price (USD/H)":0.504,"price (USD/M)":374.976}}
```

## Requirement

- Ruby(MRI) 2.3.0 or higher

## Competitors

- [Amazon Web Services Simple Monthly Calculator](https://calculator.s3.amazonaws.com/index.html)
- [Amazon EC2 Instance Comparison](https://www.ec2instances.info/)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kyoshidajp/ec2spec.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
