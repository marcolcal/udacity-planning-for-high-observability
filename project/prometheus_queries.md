## Availability SLI
### The percentage of successful requests over the last 5m
sum (rate(apiserver_request_total{job="apiserver",code!~"5.."}[2d])) / sum (rate(apiserver_request_total{job="apiserver"}[2d]))

## Latency SLI
### 90% of requests finish in these times
(   sum(rate(apiserver_request_duration_seconds_bucket{job="apiserver", le="0.1"}[5m]))   /   sum(rate(apiserver_request_duration_seconds_count{job="apiserver"}[5m])) ) * 100
## Throughput
### Successful requests per second
sum(rate(apiserver_request_total{job="apiserver", code=~"2.."}[5m]))

## Error Budget - Remaining Error Budget
### The error budget is 20%
1 - ((1 - (sum(increase(apiserver_request_total{job="apiserver", code="200"}[7d])) by (verb)) / sum(increase(apiserver_request_total{job="apiserver"}[7d])) by (verb)) / (1 - .80))

