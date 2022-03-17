import threadpool
import httpclient
import cpuinfo
import system
import strutils
import urlly
import sequtils
import os
const  reflect_str  = "REFLECT_STR"
var include_header = false
var file_location {.threadvar.}:string
if paramCount() == 1:
  echo "invalid argument"
  quit()
if paramCount() > 1:
   var a_key =  paramStr(1)
   if a_key != "--header":
      echo "invalid argument, please use [--header filename]"
      quit()
   file_location = paramStr(2)
   if not fileExists(file_location):
      echo "file not found at "&file_location
      quit()
   include_header = true
var thread_count = countProcessors()
if thread_count == 0:
    echo "Failed to Get Process Count!"
    quit()

setMaxPoolSize(thread_count)
var input = readAll(stdin)
proc make_request(site:seq[string]):void=
     for s in site:
        try:
          var client = newHttpClient()
          var content = client.request(s,HttpGet)
          var body = content.body()
          var query_url = parseUrl(s)
          for q in query_url.query:
              var value = q[1]
              var key = q[0]
              if value in body:
                echo s & "\u001b[32m ["&key&"="&value&"]"&" may be reflected in body!\u001b[0m"
          client.close()
          if include_header:
            for head in lines(file_location):
               var client_h = newHttpClient()
               client_h.headers = newHttpHeaders({head:reflect_str})
               var content_h = client_h.request(s,HttpGet)
               if reflect_str in content_h.body():
                 echo s & "\u001b[32m [header => "&head&"]"&" may be reflected in body!\u001b[0m"
               client_h.close()
        except:
          discard

var all_url = split(input,"\n")
var sub_seq = all_url.distribute(thread_count)
for s in sub_seq:
  spawn make_request(s)
sync()



