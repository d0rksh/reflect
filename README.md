# Reflect :globe_with_meridians:


## Usage 
 `cat url_get.txt | ./reflect "--header" "./headers.txt"`
 
## Output
`https://victim.com/response?agentNumber=045392 [agentNumber=045392] may be reflected in body!`

`https://victim.com/response [X-Forwarded-Host=reflect.com] may be reflected in body!` 

## Headers
  ```txt
  x-forward-for
  x-forwarded-for
  x-forwarded-for-original
  x-forwarded-host
  x-forwarded
  x-forwarded-by
  x-forwarded-server
  x-forwarder-for
  ```

