# httpd :mag:

A Ruby command line tool for looking up details of http statuses<br/>
The "d" stands for "details"

## Installation

```github
$ gem install httpd
```

## Usage

Show a master list of all http statuses:

```github
$ httpd -s
```

Pinpoint a specific status, which will give a short synopsis of it

```github
$ httpd -s 200
200 OK (Success)
Standard response for succesful HTTP requests. The actual response will depend on the request method used. In a GET request, the response will contain an entity correspoding to the requested resource.
```


`-jp`を末尾につけたら、日本語の詳細は表示されます：

```github
$ httpd -s 200 -jp
200 OK (Success)
OK。リクエストは成功し、レスポンスとともに要求に応じた情報が返される。ブラウザでページが正しく表示された場合は、ほとんどがこのステータスコードを返している。
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/gazayas/httpd.
