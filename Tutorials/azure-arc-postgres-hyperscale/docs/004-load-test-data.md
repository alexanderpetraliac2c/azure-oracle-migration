# Load test data

First of all, to test scaling out, its helpful to have test data. We utilize a sample of publicly available GitHub data, available from the Citus Data website (Citus Data is part of Microsoft).

Download the `users.csv` and `events.csv` data files to your working directory you're connecting to the database from:

```terminal
wget https://examples.citusdata.com/users.csv
wget https://examples.citusdata.com/events.csv
```

Let's connect to our database:

```terminal
azdata postgres server endpoint -n <name of your postgresql server group> -ns <name of the namespace>

#Example:
#azdata postgres server endpoint -n pg1 -ns arc
```

Example output:

```terminal
Description           Endpoint
--------------------  ----------------------------------------------------------------------------------------------------------------
Log Search Dashboard  https://10.0.0.4:30777/kibana/app/kibana#/discover?_a=(query:(language:kuery,query:'cluster_name:"pg1"'))
Metrics Dashboard     https://10.0.0.4:30777/grafana/d/postgres-metrics?var-Namespace=default&var-Name=pg1
PostgreSQL Instance   postgresql://postgres:password@10.0.0.4:31815
```

Connect to the Postgres instance using psql:

```terminal
psql postgresql://postgres:password@10.0.0.4:31815
```

And verify that we currently have two Hyperscale (Citus) worker nodes, each corresponding to a Kubernetes pod:

```sql
SELECT * FROM pg_dist_node;
```

```terminal
 nodeid | groupid |                       nodename                        | nodeport | noderack | hasmetadata | isactive | noderole | nodecluster | metadatasynced | shouldhaveshards
--------+---------+-------------------------------------------------------+----------+----------+-------------+----------+----------+-------------+----------------+------------------
      1 |       1 | pg1-1.pg1-svc.default.svc.cluster.local |     5432 | default  | f           | t        | primary  | default     | f              | t
      2 |       2 | pg1-2.pg1-svc.default.svc.cluster.local |     5432 | default  | f           | t        | primary  | default     | f              | t
(2 rows)
```

Now we’re going to set up our two tables:

```sql
CREATE TABLE github_events
(
    event_id bigint,
    event_type text,
    event_public boolean,
    repo_id bigint,
    payload jsonb,
    repo jsonb,
    user_id bigint,
    org jsonb,
    created_at timestamp
);

CREATE TABLE github_users
(
    user_id bigint,
    url text,
    login text,
    avatar_url text,
    gravatar_id text,
    display_login text
);
```

On the payload field of events we have a JSONB datatype. JSONB is the JSON datatype in binary form in Postgres. This makes it easy to store a more flexible schema in a single column and with Postgres we can create a GIN index on this which will index every key and value within it. With a GIN index it becomes fast and easy to query with various conditions directly on that payload. So we’ll go ahead and create a couple of indexes before we load our data:

```sql
CREATE INDEX event_type_index ON github_events (event_type);
CREATE INDEX payload_index ON github_events USING GIN (payload jsonb_path_ops);
```

Next we’ll actually take those standard Postgres tables and tell Citus to shard them out. To do so we’ll run a query for each table. With this query we’ll specify the table we want to shard, as well as the key we want to shard it on. In this case we’ll shard both the events and users table on user_id:

```sql
SELECT create_distributed_table('github_events', 'user_id');
SELECT create_distributed_table('github_users', 'user_id');
```

Now, Load the data with \copy:

```terminal
\copy github_events from events.csv CSV;
\copy github_users from users.csv CSV;
```

We can utilize the `\timing` setting in `psql` to get execution times:

```terminal
\timing
```

And now lets take a measurement for how long a simple query takes with two nodes:

```sql
SELECT COUNT(*) FROM github_events;
```

```terminal
 count  
--------
 126245
(1 row)

Time: 30.401 ms
```