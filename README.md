# aws-mq-cli

The Command Line Interface for Amazon MQ.

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

# stress test
aws-mq-cli stress publish <qps> [<payload size(KB)>]
aws-mq-cli stress consume <qps>

# tutorial (RabbitMQ)
aws-mq-cli tutorial hello_world
aws-mq-cli tutorial work_queues
```
