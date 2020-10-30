import boto3
import sys
import csv
from datetime import datetime, timedelta
import time


def argument_check(argv):
  arguments = len(argv) -1
  if arguments == 0:
    logs_tpye = 1
    print("default log type: 1 - vcp flowlogs")
  elif arguments == 1:
    logs_tpye = int(argv[1])
    if logs_tpye not in [1,2]: 
      print("Input argument value error, please input the value of query type: 1 or 2. 1 - vcp flowlogs 2 - appache-access-log, the default value is 1. " )
      logs_tpye = -1
  else:
    print("Input arugenment number error, please input no more than one argument(query type). 1 - vcp flowlogs 2 - appache-access-log, the default value is 1.")
    logs_tpye = - 1
  return logs_tpye

# https://stackoverflow.com/questions/23294658/asking-the-user-for-input-until-they-give-a-valid-response
# check input until give a valid response
def sanitised_input(prompt, type_=None, min_=None, max_=None, range_=None):
    if min_ is not None and max_ is not None and max_ < min_:
        raise ValueError("min_ must be less than or equal to max_.")
    while True:
        ui = input(prompt)
        if type_ is not None:
            try:
                ui = type_(ui)
            except ValueError:
                print("Input type must be {0}.".format(type_.__name__))
                continue
        if max_ is not None and ui > max_:
            print("Input must be less than or equal to {0}.".format(max_))
        elif min_ is not None and ui < min_:
            print("Input must be greater than or equal to {0}.".format(min_))
        elif range_ is not None and ui not in range_:
            if isinstance(range_, range):
                template = "Input must be between {0.start} and {0.stop}."
                print(template.format(range_))
            else:
                template = "Input must be {0}."
                if len(range_) == 1:
                    print(template.format(*range_))
                else:
                    expected = " or ".join((
                        ", ".join(str(x) for x in range_[:-1]),
                        str(range_[-1])
                    ))
                    print(template.format(expected))
        else:
            return ui

# https://stackoverflow.com/questions/59240107/how-to-query-cloudwatch-logs-using-boto3-in-python
# query CloudWatch logs
def get_query_logs(log_group, query,day_number):
  client = boto3.client('logs')
  try:
    start_query_response = client.start_query(
    logGroupName=log_group,
    startTime=int((datetime.today() - timedelta(days=day_number)).timestamp()),
    endTime=int(datetime.now().timestamp()),
    queryString=query
  )
  except ClientError as e:
    raise e
  query_id = start_query_response['queryId']
  response = None
  while response == None or response['status'] == 'Running':
      print('Waiting for query to complete ...')
      time.sleep(1)
      try:
        response = client.get_query_results(
            queryId=query_id
        )
      except ClientError as e:
        raise e
  logs = [] 
  for log in response['results']:
    logs.append(log)
  return logs

  # can_paginate = client.can_paginate('get_query_results')
  # if not can_paginate:
  #   print('There is no built-in paginator for that method') 

# write CSV
def CSV_Writer(content, header):
  with open('export.csv', 'w') as csvFile:
    writer = csv.DictWriter(csvFile, fieldnames=header)
    writer.writeheader()
    for row in content:
        writer.writerow(row)

# export logs query reslut to CSV file
def main():
  log_type = argument_check(sys.argv)
  if log_type == -1: 
    return
  day_number = sanitised_input("Enter the number of day: ", int, 1, 10)
  if log_type == 1:  
    log_group = "vpc_flowlog_loggroup"
    query = "filter action='REJECT' and dstPort='80' | stats count(*) as sumRequest by srcAddr | sort sumRequest desc" 
  else:
     log_group = "apache-access-log"
     query = "parse @message '* - - [*] \"* * *\" * * \"*\" \"*\"'as srcAddr, dateTimeString, method, path, protocol, statusCode, bytes, referer, browser | filter statusCode='404' | stats count(*) as sumRequest by srcAddr" 
  logs = []
  logs = get_query_logs(log_group, query, day_number)
  if not logs:
    print("No log record.")
  else:
    # print(logs)
    header = ['srcAddr', 'sumRequest']
    data = []
    for log in logs:
      print(log)
      data.append(
        {
          "srcAddr": log[0]['value'],
          "sumRequest": log[1]['value']
        }
      )
    CSV_Writer(content=data,header=header)
    print("Successfully Exported the logs to CSV file!")
  return

if __name__ == "__main__":
  main()