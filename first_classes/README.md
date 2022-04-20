# Elixir Syntax

During the first class, we will learn basic Elixir data types and syntax.
We will be using a new tool called `livebook`.

## How to start?

### fly.io
You can launch `livebook` instance using https://fly.io/launch/livebook and following instructions on the website.

### docker
Alternately you can run `livebook` instance in a docker container on your local machine:

```bash
docker run -p 8080:8080 -p 8081:8081 --pull always -v $(pwd):/data livebook/livebook
```

or following the instructions from: https://github.com/livebook-dev/livebook#docker

## Data types

Start with learning about basic data types. In your livebook open `first_classes/data_types.livemd`
