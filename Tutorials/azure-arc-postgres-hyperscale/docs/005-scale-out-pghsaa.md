# Scenario: Scale out your Azure Database for PostgreSQL Hyperscale server group

## Scaling out

Increase the number of worker nodes to 4, by running the following command:

```terminal
azdata postgres server update -n <name of your postgresql server group> -ns <name of the namespace> -w <number of workers>

#Example:
#azdata postgres server update -n pg1 -ns  -w 4
```

This will first start adding the nodes, and you'll see a Pending state for the server group:

```terminal
azdata postgres server list
ClusterIP         ExternalIP      MustRestart    Name        Status
----------------  --------------  -------------  ----------  -----------
10.98.62.6:31815  10.0.0.4:31815  False          pg1  Pending 4/5
```

Once the nodes are available, the Hyperscale (Citus) Shard Rebalancer runs automatically, and redistributes the data to the new nodes.

> **Note:** During this scale out operation the database remains fully online, and we can continue running queries.

You can verify that the new nodes are available:

```sql
SELECT * FROM pg_dist_node;
```

```terminal
 nodeid | groupid |                       nodename                        | nodeport | noderack | hasmetadata | isactive | noderole | nodecluster | metadatasynced | shouldhaveshards
--------+---------+-------------------------------------------------------+----------+----------+-------------+----------+----------+-------------+----------------+------------------
      1 |       1 | pg1-1.pg1-svc.default.svc.cluster.local |     5432 | default  | f           | t        | primary  | default     | f              | t
      2 |       2 | pg1-2.pg1-svc.default.svc.cluster.local |     5432 | default  | f           | t        | primary  | default     | f              | t
      3 |       3 | pg1-3.pg1-svc.default.svc.cluster.local |     5432 | default  | f           | t        | primary  | default     | f              | t
      4 |       4 | pg1-4.pg1-svc.default.svc.cluster.local |     5432 | default  | f           | t        | primary  | default     | f              | t
(4 rows)
```

And now the same count query can be performed across the four worker nodes, without any changes in the SQL statement.

If you deploy on a single VM for testing this likely has similar runtime as before, if you deploy on a production-sized multi-node cluster, the performance should have increased:

```sql
SELECT COUNT(*) FROM github_events;
```

```terminal
 count  
--------
 126245
(1 row)

Time: 15.427 ms
```
