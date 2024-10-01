# Infrastructure

## AWS Zones
Identify your zones here
Zone 1 = us-east-2 [us-east-2a, us-east-2b]
Zone 2 = us-west-1 [us-west-1a, us-west-1b]

## Servers and Clusters

### Table 1.1 Summary
|   | Asset                | Purpose                   | Size                                                                   | Qty                                                             | DR                                                                                                           |   |
|---|----------------------|---------------------------|------------------------------------------------------------------------|-----------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------|---|
|   | EC2 Instance         | Web Server                | t3.micro                                                               | 3                                                               | failover in us-west-1                                                                                        |   |
|   | EC2 Instance Replica | Web Server 2              | t3.micro                                                               | 3                                                               | exact copy from us-east-2                                                                                    |   |
|   | EKS Cluster          | Monitoring Cluster        | t3.medium                                                              | 1 control and 2 max nodes                                       | failover in us-west-1                                                                                        |   |
|   | EKS Cluster Replica  | Monitoring Cluster        | t3.medium                                                              | 1 control and 2 max nodes                                       | exact copy from us-east-2                                                                                    |   |
|   | Load Balancer        | Application Load Balancer |                                                                        | 2                                                               | one on each zone                                                                                             |   |
|   | RDS Cluster          | Database Cluster          | Database Cluster                                                       |                                                                 |                                                                                                              |   |
|   | RDS Server           | Database Server           | db.t2.small                                                            | 1 instance                                                      | replicate on us-west-1                                                                                       |   |
|   | RDS Cluster Replica  | Database Cluster          | Database Cluster                                                       |                                                                 | Copy from us-east-2                                                                                          |   |
|   | RDS Server           | Database Server           | db.t2.small                                                            | 1 instance                                                      | replicate on us-west-1                                                                                       |   |
|   | S3 Bucket            | Storage                   | amazon standard                                                        | 1                                                               | us-east-2                                                                                                    |   |
|   | S3 Bucket West       | Storage                   | amazon standard                                                        | 1                                                               | us-west-1                                                                                                    |   |
|   | Asset name           | Brief description         | AWS size eg. t3.micro (if applicable, not all assets will have a size) | Number of nodes/replicas or just how many of a particular asset | Identify if this asset is deployed to DR, replicated, created in multiple locations or just stored elsewhere |   |

### Descriptions
More detailed descriptions of each asset identified above:

EC2 Instances: These serve as application servers and are deployed across two zones to enable failover capabilities.
EKS Cluster and Node Group: These are utilized to deploy the monitoring stack and are also deployed across both zones.
Load Balancer: This is positioned in front of both zones and dynamically manages traffic along with failover configurations.
RDS Cluster and Database Server: These are mirrored across each zone, allowing us to configure backup and replication policies for high availability (HA).
S3 Buckets: These are deployed in both zones for storing Terraform objects.
## DR Plan
Disaster Recovery Strategy:
1. High Availability and Failover:
EC2 Instances: Maintain 3 EC2 instances in a separate region/zone with High Availability (HA) enabled to ensure continuous service availability.
Load Balancer: Implement a load balancer to manage API traffic across EC2 instances, ensuring efficient distribution and failover.

2. Data Replication and Backup:
RDS Cluster: Utilize a replicated cluster of 3 Amazon RDS nodes across regions to ensure data integrity and availability. The primary region hosts the active database, while the secondary region holds the replica.
S3 Buckets: Regularly back up database and essential data to S3 buckets. Ensure that backups are stored in multiple regions to safeguard against regional failures.

3. Monitoring and Alerting:
EKS Cluster: Deploy a Kubernetes cluster dedicated to running the monitoring stack. This setup should mirror the configuration across regions to continuously monitor system health and trigger alerts in case of anomalies.

### Pre-Steps:
List steps you would perform to setup the infrastructure in the other region. It doesn't have to be super detailed, but high-level should suffice.
1. Plan and design
2. Asses some of the requirements
3. Choose the regions
4. Use terraform to deploy same infrastructure.
5. Configure database policies for replication and backups
6. Configure storage for same
7. Configure load balancers
8. Configure monitorig for these resources

## Steps:
You won't actually perform these steps, but write out what you would do to "fail-over" your application and database cluster to the other region. Think about all the pieces that were setup and how you would use those in the other region

1. Redirect traffic from the primary to the seconday zone using the load balancer.
2. Scale up as needed or restore from snapshots if needed.
3. Data replication will be as easy as to manually switch the database operations from the primary cluster to failover cluster in different zone.
4. Restore database logs and data as needed from backups
5. System checks to ensure we are up and running.
6. Some type of data intergrity validation.
7. Communicate to stake holders as needed.
8. Perform a post-mortem disaster review to be sure that document all performed steps.