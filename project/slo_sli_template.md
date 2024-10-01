# API Service

| Category     | SLI | SLO |
|--------------|-----|-----|
| Availability | total number of successful requests / total number of requests | 99% |
| Latency      | buckets of requests in a histogram showing the 90th percentile over the last 30 seconds    | 90% of requests below 100ms |
| Error Budget | It shows how much is left of your error budget.    | Error budget is defined at 20%. This means that 20% of the requests can fail and still be within the budget |
| Throughput   | total number of successful requests over 5 minutes    | 5 RPS indicates the application is functioning|


Let's look at some SLO/SLI examples. Here is the first example about availability
SLO: 90% availability
sum (rate(apiserver_request_total{job="apiserver",code!~"5.."}[2d]))/sum (rate(apiserver_request_total{job="apiserver"}[2d]))
SLI: total number of successful requests / total number of requests
Here is the Prometheus query that corresponds to the SLO/SLI:
http_request_total { code =~ "200" } / http_request_total
http_request_total{code =~ "200"} is the total number of successful requests and http_request_total is the total number of requests.


Here is an SLO/SLI combination for latency:
histogram_quantile(0.95,sum(rate(apiserver_request_duration_seconds_bucket{job="apiserver"}[5m])) by (le, verb))
(sum(rate(apiserver_request_duration_seconds_bucket{job="apiserver", le="0.1"}[5m]))/sum(rate(apiserver_request_duration_seconds_count{job="apiserver"}[5m]))) * 100
SLO: 90% of requests served within 50ms over the last 30 seconds
SLI: buckets of requests in a histogram showing the 90th percentile over the last 30 seconds
Here's the query:
histogram_quantile(0.90, sum(rate(http_request_duration_seconds_bucket{job="website"}[30s])) by (le, verb))
Here we see histogram_quantile as the main function. .90 is the percentage top we want. sum summarizes the group labels. rate is the per-second average rate of increase over a period of time. job="website" is targeting a specific label for the query. 30s is part of the rate to define over which period we want to measure the latency. by (le, verb) tells Prometheus to group by HTTP verbs (like GET, PUT, etc.) and le. le is required by histogram_quantile.


Let's look at another category - throughput. Here are the SLO/SLI example and the matching query:
SLO: throughput of 100 requests per second (RPS) over 5 minutes
SLI: total number of successful requests over 5 minutes
sum(rate(apiserver_request_total{job="apiserver",code=~"2.."}[5m]))
The query is:
sum(rate(http_request_total{code=~"2.."}[5m]))




And now, we come to the error budget. The error budget itself is a static number. How you display the error budget can vary depending on what you want to see.

A useful display of the error budget is the percentage of the remaining error budget. It shows how much is left of your error budget.

Take a look at some formulas below:

% error occurred = 1 - compliance = 1 - successful requests/total requests
Ex: there are 100 requests total and 97 are successful. So the % error occurred is 1 - 97/100 = 0.03 = 3%.
error budget = 1 - availability
Ex: availability is 90%, so the error budget is 10%.
% error used = % error occurred/error budget
Ex: there are 3% error requests and the error budget is 10%. 3%/10% = 0.3 = 30%, so 30% of the error budget is used.
% remaining error budget = 1- % error used
Ex: 30% of the error budget is used, meaning 1 - 30% = 70% of the error budget is remaining.
We can bring these formulas together to form this query for error budget:

1 - ((1 - (sum(increase(http_request_total{job="webserver", code="200"}[7d])) by (verb)) /  sum(increase(http_request_total{job="webserver"}[7d])) by (verb)) / (1 - .90))
sum(increase(http_request_total{job="webserver", code="200"}[7d])) by (verb)) is the successful requests. Notice the 200 code for successful requests. We use increase here. Just know it is another form of rate that works better when dealing with percentages. Notice too we define 7d as the time period.

sum(increase(http_request_total{job="webserver"}[7d])) by (verb)) is the total number of requests. Notice the lack of the 200 code for all requests.

(1 - .90) is the actual error budget percentage.

1 - ((1 - (sum(increase(apiserver_request_total{job="apiserver", code="200"}[7d])) by (verb)) / sum(increase(apiserver_request_total{job="apiserver"}[7d])) by (verb)) / (1 - .80))