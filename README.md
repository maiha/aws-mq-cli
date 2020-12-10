# aws-mq-cli

The Command Line Interface for Amazon MQ.


## Installation
* x86_64 static binary: https://github.com/maiha/aws-mq-cli/releases

```console
$ wget https://github.com/maiha/aws-mq-cli/releases/latest/download/aws-mq-cli
```

## Connection setttings

* **endpoint** : `amqps://b-764397a6-e097-4h6s-86e4-ds77a5885869.mq.us-west-2.amazonaws.com:5671`
* **credentials** : `user`, `password`

These can be specified in following priorities:

1. Command line args
2. The `.env` file in current dir
3. Shell environment variables

##### Command line args

```console
usage: aws-mq-cli [option] <command> <task> [args]
  -e, --endpoint-uri <URI>         endpoint uri
  -a, --auth <USER:PASSWORD>       user credentials

$ aws-mq-cli <command> <task> -e "amqps://b-764397a6-e097-4h6s-86e4-ds77a5885869.mq.us-west-2.amazonaws.com:5671" -a "user:password"
```

##### The `.env` file in current dir

```console
$ vi .env
AMAZON_MQ_URI=amqps://b-764397a6-e097-4h6s-86e4-ds77a5885869.mq.us-west-2.amazonaws.com:5671
AMAZON_MQ_AUTH=user:password
```

##### Shell environment variables

```console
$ export AMAZON_MQ_URI=amqps://b-764397a6-e097-4h6s-86e4-ds77a5885869.mq.us-west-2.amazonaws.com:5671
$ export AMAZON_MQ_AUTH=user:password
```

## API

```console
# queue
aws-mq-cli queue create <queue_name>
aws-mq-cli queue delete <queue_name>
aws-mq-cli queue purge  <queue_name>

# exchange
aws-mq-cli exchange create  <name> <type>
aws-mq-cli exchange declare <name> <type>
aws-mq-cli exchange delete  <name>

# publish
aws-mq-cli exchange publish <exchange> <message>

# samples
aws-mq-cli samples ack_nack
aws-mq-cli samples priority_queue

# stress test
aws-mq-cli stress publish <qps> [<payload size(KB)>]
aws-mq-cli stress consume <qps>

# tutorials (RabbitMQ)
aws-mq-cli tutorials hello_world
aws-mq-cli tutorials work_queues
```
