# httpd :mag:

A Ruby command line tool for looking up details of http statuses<br/>
The "d" stands for "details"

## Installation

`$ gem install httpd`

## Usage

Show a master list of all http statuses:

```github
$ httpd -s
```

Pinpoint a specific status, which will give a short synopsis of it

```github
$ httpd -s 200
```


`-jp`を語尾につけたら、日本語の詳細は表示されます：

```github
$ httpd -s 200 -jp
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/gazayas/httpd.
