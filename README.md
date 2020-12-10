# aws-mq-cli

The Command Line Interface for Amazon MQ.


## Installation
* x86_64 static binary: https://github.com/maiha/aws-mq-cli/releases

```console
$ wget https://github.com/maiha/aws-mq-cli/releases/latest/download/aws-mq-cli
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

# stress test
aws-mq-cli stress publish <qps> [<payload size(KB)>]
aws-mq-cli stress consume <qps>

# tutorials (RabbitMQ)
aws-mq-cli tutorials hello_world
aws-mq-cli tutorials work_queues
```
