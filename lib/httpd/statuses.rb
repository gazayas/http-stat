module Httpd

  # TODO: detailsにエスケープキーで使われる「\」がないか確認すること

  Statuses = [
    {
      number: 100,
      status: 'Continue',
      details: 'The server has received the request headers and the client should proceed to send the request body ' +
                '(in case of a request for which a body needs to be sent; for example, a POST request). Sending a large request ' +
                'body to a server after a request has been rejected for inappropriate headers would be inefficient. To have a ' +
                'server check the request\'s headers, a client must sent Expect: 100-continue as a header in its initial request ' +
                'and receive a 100 Continue status code in response before sending the body. The response 417 Expectation Failed ' +
                'indicates the request should not be continued',
      details_jp: '継続。クライアントはリクエストを継続できる。サーバがリクエストの最初の部分を受け取り、まだ拒否していないことを示す。' +
                '例として、クライアントがExpect: 100-continueヘッダをつけたリクエストを行い、それをサーバが受理した場合に返される。'
    },
    {
      number: 101,
      status: 'switching protocols',
      details: 'The requester has asked the server to switch protocols and the server has agreed to do so',
      details_jp: 'プロトコル切替え。サーバはリクエストを理解し、遂行のためにプロトコルの切替えを要求している。'
    },
    {
      number: 102,
      status: 'Processing',
      details: 'A WebDAV request may contain many sub-requests involving file operations, requiring a long time to ' +
                'complete the request. This code indicates that the server has received and is processing the request, but ' +
                'no response is available yet. This prevents the client from timing out and assuming the request was lost',
      details_jp: '処理中。WebDAVの拡張ステータスコード。処理が継続されて行われていることを示す。'
    },


    {
      number: 200,
      status: 'OK',
      details: 'Standard response for succesful HTTP requests. The actual response will depend on the request ' +
                'method used. In a GET request, the response will contain an entity correspoding to the requested resource.',
      details_jp: 'OK。リクエストは成功し、レスポンスとともに要求に応じた情報が返される。' +
                  'ブラウザでページが正しく表示された場合は、ほとんどがこのステータスコードを返している。'
    },
    {
      number: 201,
      status: 'Created',
      details: 'The request has been fulfilled, resulting in the creation of a new resource.',
      details_jp: '作成。リクエストは完了し、新たに作成されたリソースのURIが返される。' +
                  '例: PUTメソッドでリソースを作成するリクエストを行ったとき、そのリクエストが完了した場合に返される。'
    },
    {
      number: 202,
      status: 'Accepted',
      details: 'The request has been accepted for processing, but the processing has not been completed. ' +
                'The request might or might not be eventually acted upon, and may be disallowed when processing occurs. ',
      details_jp: '受理。リクエストは受理されたが、処理は完了していない。' +
                  '例: PUTメソッドでリソースを作成するリクエストを行ったとき、サーバがリクエストを受理したものの、リソースの作成が完了' +
                  'していない場合に返される。バッチ処理向け。'
    },
    {
      number: 203,
      status: 'Non-Autoritative Information (since HTTP/1.1)',
      details: 'The server is a transforming proxy (e.g. a Web accelerator) that received a 200 OK from its ' +
                'origin, but is returning a modified version of the origin\'s response.',
      details_jp: '信頼できない情報。オリジナルのデータではなく、ローカルやプロキシ等からの情報であることを示す。'
    },
    {
      number: 204,
      status: 'No Content',
      details: 'The server successfully processed the request and is not returning any content.',
      details_jp: '内容なし。リクエストを受理したが、返すべきレスポンスエンティティが存在しない場合に返される。' +
                  '例: POSTメソッドでフォームの内容を送信したが、ブラウザの画面を更新しない場合に返される。'
    },
    {
      number: 205,
      status: 'Reset Content',
      details: 'The server successfully processed the request, but is not returning any content. Unlike a ' +
                '204 response, this response requires that the requester reset the document view.',
      details_jp: '内容のリセット。リクエストを受理し、ユーザエージェントの画面をリセットする場合に返される。' +
                  '例: POSTメソッドでフォームの内容を送信した後、ブラウザの画面を初期状態に戻す場合に返される。'
    },
    {
      number: 206,
      status: 'Partial Content (RFC 7233)',
      details: 'The server is delivering only part of the resource (byte serving) due to a range header sent ' +
                'by the client. The range header is used by HTTP clients to enable resuming of interrupted downloads, ' +
                'or split a download into multiple simultaneous streams.',
      details_jp: '部分的内容。部分的GETリクエストを受理したときに、返される。' +
                  '例: ダウンロードツール等で分割ダウンロードを行った場合や、レジュームを行った場合に返される。'
    },
    {
      number: 207,
      status: 'Multi-Status (WebDAV; RFC 4918)',
      details: 'The message body that follows is an XML message and can contain a number of separate repsonse ' +
              'codes, depending on how many sub-requests were made.',
      details_jp: '複数のステータス。WebDAVの拡張ステータスコード。'
    },
    {
      number: 208,
      status: 'Already Reported (WebDAV; RFC 5842)', 
      details: 'The members of a DAV binding have already been enumerated in a previous reply to this request, ' +
                'and are not being included again.',
      details_jp: '既に報告。WebDAVの拡張ステータスコード。'
    },
    {
      number: 226,
      status: 'IM Used',
      details: 'The server has fulfilled a request for the resource, and the response is a representation of ' +
                'the result of one or more instance-manipulations applied to the current instance.',
      details_jp: 'IM使用。Delta encoding in HTTPの拡張ステータスコード。'
    },


    {
      number: 300,
      status: 'Multiple Choices',
      details: 'Indicates multiple options for the resource from which the client may choose (via agent-driven ' +
                'content negotiation). For example, this code could be used to present multiple video format options, to ' +
                'list files with different filename extensions, or to suggest word-sense disambiguation.',
      details_jp: '複数の選択。リクエストしたリソースが複数存在し、ユーザやユーザーエージェントに選択肢を提示するときに' +
                  '返される。具体例として、W3Cのhttp://www.w3.org/TR/xhtml11/DTD/xhtml11.html'
    },
    {
      number: 301,
      status: 'Moved Permanently',
      details: 'This and all future requests should be directed to the given URI',
      details_jp: '恒久的に移動した。リクエストしたリソースが恒久的に移動されているときに返される。' +
                  'Location:ヘッダに移動先のURLが示されている。例としては、ファイルではなくディレクトリに対応するURLの末尾に/を書かずに' +
                  'アクセスした場合に返される。具体例として、http://www.w3.org/TR'
    },
    {
      number: 302,
      status: 'Found',
      details: 'This is an example of industry practice contradicting the standard. The HTTP/1.0 specification ' +
                '(RFC 1945) required the client to perform a temporary redirect (the original describing phrase was ' +
                '"Moved Temporarily"), but popular browsers implemented 302 with the functionality of a 303 See Other. ' +
                'Therefore, HTTP/1.1 added status codes 303 and 307 to distinguish between the two behaviours.' +
                'However, some Web applications and frameworks use the 302 status code as if it were the 303.',
      details_jp: '発見した。リクエストしたリソースが一時的に移動されているときに返される。Location:ヘッダに移動先のURLが示されている。' +
                  '元々はMoved Temporarily（一時的に移動した）で、本来はリクエストしたリソースが一時的にそのURLに存在せず、別のURLにある' +
                  '場合に使用するステータスコードであった。しかし、例えば掲示板やWikiなどで投稿後にブラウザを他のURLに転送したいときにもこの' +
                  'コードが使用されるようになったため、302はFoundになり、新たに303・307が作成された。'
    },
    {
      number: 303,
      status: 'See Other (since HTTP/1.1)',
      details: 'The response to the request can be found under another URI using a GET method. When received ' +
                'in response to a POST (or PUT/DELETE), the client should presume that the server has received the data ' +
                'and should issue a redirect with a separate GET message.',
      details_jp: '他を参照せよ。リクエストに対するレスポンスが他のURLに存在するときに返される。Location:ヘッダに移動先のURLが示されている。' +
                  'リクエストしたリソースは確かにそのURLにあるが、他のリソースをもってレスポンスとするような場合に使用する。' +
                  '302の説明で挙げたような、掲示板やWikiなどで投稿後にブラウザを他のURLに転送したいときに使われるべきコードとして導入された。'
    },
    {
      number: 304,
      status: 'Not Modified (RFC 7232)',
      details: 'Indicates that the resource has not been modified since the version specified by the request headers ' +
                'If-Modified-Since or If-None-Match. In such case, there is no need to retransmit the resource since the client ' +
                'still has a previously-downloaded copy',
      details_jp: ''
    },
    {
      number: 305,
      status: 'Use Proxy (since HTTP/1.1)',
      details: 'The requested resource is available only through a proxy, the address for which is provided in the ' +
                'response. Many HTTP clients (such as Mozilla and Internet Explorer) do not correctly handle responses with this ' +
                'status code, primarily for security reasons.',
      details_jp: 'プロキシを使用せよ。レスポンスのLocation:ヘッダに示されるプロキシを使用してリクエストを行わなければならないことを示す。'
    },
    {
      number: 306,
      status: 'Switch Proxy',
      details: 'No longer used. Originally meant "Subsequent requests should use the specified proxy."',
      details_jp: '将来のために予約されている。ステータスコードは前のバージョンの仕様書では使われていたが、もはや使われておらず、' +
                  '将来のために予約されているとされる。検討段階では、「Switch Proxy」というステータスコードが提案されていた。'
    },
    {
      number: 307,
      status: 'Temporary Redirect (since HTTP/1.1)',
      details: 'In this case, the request should be repeated with another URI; however, future requests should still ' +
                'use the original URI. In contrast to how 302 was historically implemented, the request method is not allowed ' +
                'to be changed when reissuing the original request. For example, a POST request should be repeated using ' +
                'another POST request.',
      details_jp: '一時的リダイレクト。リクエストしたリソースは一時的に移動されているときに返される。Location:ヘッダに移動先のURLが示されている。' +
                  '302の規格外な使用法が横行したため、302の本来の使用法を改めて定義したもの。'
    },
    {
      number: 308,
      status: 'Permanent Redirect(RFC 7538)',
      details: 'The request and all future requests should be repeated using another URI. 307 and 308 parallel the ' +
                'behaviors of 302 and 301, but do not allow the HTTP method to change. So, for example, submitting a form to ' +
                'a permanently redirected resource may continue smoothly.',
      details_jp: '恒久的リダイレクト。'
    },


    {
      number: 400,
      status: 'Bad Request',
      details: 'The server cannot or will not process the request due to an apparent client error (e.g., malformed '+
                'request syntax, too large size, invalid request message framing, or deceptive request routing).',
      details_jp: 'リクエストが不正である。定義されていないメソッドを使うなど、クライアントのリクエストがおかしい場合に返される。'
    },
    {
      number: 401,
      status: 'Unauthorized',
      details: 'Similar to 403 Forbidden, but specifically for use when authentication is required and has failed ' +
                'or has not yet been provided. The response must include a WWW-Authenticate header field containing a ' +
                'challenge applicable to the requested resource. See Basic access authentication and Digest access authentication. ' +
                'semantically means "unauthenticated", i.e. the user does not have the necessary credentials. ' +
                'Note: Some sites issue HTTP 401 when an IP address is banned from the website (usually the website domain) and ' +
                'that specific address is refused permission to access a website.',
      details_jp: '認証が必要である。Basic認証やDigest認証などを行うときに使用される。たいていのブラウザはこのステータスを' +
                  '受け取ると、認証ダイアログを表示する。'
    },
    {
      number: 402,
      status: 'Payment Required',
      details: 'Reserved for future use. The original intention was that this code might be used as part of some ' +
                'form of digital cash or micropayment scheme, but that has not happened, and this code is not usually used. ' +
                'Google Developers API uses this status if a particular developer has exceeded the daily limit on requests.',
      details_jp: '支払いが必要である。現在は実装されておらず、将来のために予約されているとされる。'
    },
    {
      number: 403,
      status: 'Forbidden',
      details: 'The request was a valid request, but the server is refusing to respond to it. The user might be logged ' +
                'in but does not have the necessary permissions for the resource.',
      details_jp: '禁止されている。リソースにアクセスすることを拒否された。リクエストはしたが処理できないという意味。' +
                  'アクセス権がない場合や、ホストがアクセス禁止処分を受けた場合などに返される。例: 社内（イントラネット）' +
                  'からのみアクセスできるページに社外からアクセスしようとした。'
    },
    {
      number: 404,
      status: 'Not Found',
      details: 'The requested resource could not be found but may be available in the future. Subsequent requests by ' +
                'the client are permissible.',
      details_jp: '未検出。リソースが見つからなかった。単に、アクセス権がない場合などにも使用される。'
    },
    {
      number: 405,
      status: 'Method Not Allowed',
      details: 'A request method is not supported for the requested resource; for example, a GET request on a form ' +
                'which requires data to be presented via POST, or a PUT request on a read-only resource.',
      details_jp: '許可されていないメソッド。許可されていないメソッドを使用しようとした。例: POSTメソッドの使用が許されていない' +
                  '場所で、POSTメソッドを使用した場合に返される。'
    },
    {
      number: 406,
      status: 'Not Acceptable',
      details: 'The requested resource is capable of generating only content not acceptable according to the Accept ' +
                'headers sent in the request.',
      details_jp: '受理できない。Accept関連のヘッダに受理できない内容が含まれている場合に返される。例: サーバは英語か日本語しか' +
                  '受け付けられないが、リクエストのAccept-Language:ヘッダにzh（中国語）しか含まれていなかった。' +
                  '例: サーバはapplication/pdfを送信したかったが、リクエストのAccept:ヘッダにapplication/pdfが含まれていなかった。' +
                  '例: サーバはUTF-8の文章を送信したかったが、リクエストのAccept-Charset:ヘッダには、UTF-8が含まれていなかった。'
    },
    {
      number: 407,
      status: 'Proxy Authentication Required (RFC 7235)',
      details: 'The client must first authenticate itself with the proxy.',
      details_jp: 'プロキシ認証が必要である。プロキシの認証が必要な場合に返される。'
    },
    {
      number: 408,
      status: 'Request Time-out',
      details: 'The server timed out waiting for the request. According to HTTP specifications: "The client did ' +
                'not produce a request within the time that the server was prepared to wait. The client MAY repeat the request ' +
                'without modifications at any later time."',
      details_jp: 'リクエストタイムアウト。リクエストが時間以内に完了していない場合に返される。'
    },
    {
      number: 409,
      status: 'Conflict',
      details: 'Indicates that the request could not be processed because of conflict in the request, such as an edit ' +
                'conflict between multiple simultaneous updates.',
      details_jp: '競合。要求は現在のリソースと競合するので完了出来ない。'
    },
    {
      number: 410,
      status: 'Gone',
      details: 'Indicates that the resource requested is no longer available and will not be available again. This ' +
                'should be used when a resource has been intentionally removed and the resource should be purged. Upon ' +
                'receiving a 410 status code, the client should not request the resource in the future. Clients such as search ' +
                'engines should remove the resource from their indices. Most use cases do not require clients and search ' +
                'engines to purge the resource, and a "404 Not Found" may be used instead.',
      details_jp: '消滅した。リソースは恒久的に移動・消滅した。どこに行ったかもわからない。404 Not Foundと似ているが、' +
                  'こちらは二度と復活しない場合に使われる。ただし、このコードは特別に設定しないと提示できないため、' +
                  'リソースが消滅しても404コードを出すサイトが多い。'
    },
    {
      number: 411,
      status: 'Length Required',
      details: 'The request did not specify the length of its content, which is required by the requested resource.',
      details_jp: '長さが必要。Content-Length ヘッダがないのでサーバがアクセスを拒否した場合に返される。'
    },
    {
      number: 412,
      status: 'Precondition Failed (RFC 7232)',
      details: 'The server does not meet one of the preconditions that the requester put on the request.',
      details_jp: '前提条件で失敗した。前提条件が偽だった場合に返される。' +
                  '例: リクエストのIf-Unmodified-Since:ヘッダに書いた時刻より後に更新があった場合に返される。'
    },
    {
      number: 413,
      status: 'Payload Too Large (RFC 7231)',
      details: 'The request is larger than the server is willing or able to process. Previously called ' +
                '"Request Entity Too Large".',
      details_jp: 'ペイロードが大きすぎる。リクエストエンティティがサーバの許容範囲を超えている場合に返す。' +
                  '例: アップローダの上限を超えたデータを送信しようとした。RFC 2616以前では、' +
                  'Request Entity Too Large（リクエストエンティティが大きすぎる）と定められていた。'
    },
    {
      number: 414,
      status: 'URI Too Long (RFC 7231)',
      details: 'The URI provided was too long for the server to process. Often the result of too much data being ' +
                'encoded as a query-string of a GET request, in which case it should be converted to a POST request. ' +
                'Called "Request-URI Too Long" previously.',
      details_jp: 'URIが大きすぎる。URIが長過ぎるのでサーバが処理を拒否した場合に返す。' +
                  '例: 画像データのような大きなデータをGETメソッドで送ろうとし、URIが何10kBにもなった場合に返す' +
                  '（上限はサーバに依存する）。RFC 2616以前では、Request-URI Too Long（リクエストURIが大きすぎる）と定められていた。'
    },
    {
      number: 415,
      status: 'Unsupported Media Type',
      details: 'The request entity has a media type which the server or resource does not support. For example, ' +
                'the client uploads an image as image/svg+xml, but the server requires that images use a different format.',
      details_jp: 'サポートしていないメディアタイプ。指定されたメディアタイプがサーバでサポートされていない場合に返す。'
    },
    {
      number: 416,
      status: 'Range Not Satisfiable (RFC 7233)',
      details: 'The client has asked for a portion of the file (byte serving), but the server cannot supply that ' +
                'portion. For example, if the client asked for a part of the file that lies beyond the end of the file. ' +
                'Called "Requested Range Not Satisfiable" previously.',
      details_jp: 'レンジは範囲外にある。実リソースのサイズを超えるデータを要求した。' +
                  'たとえば、リソースのサイズが1024Byteしかないのに、1025Byteを取得しようとした場合などに返す。' +
                  'RFC 2616以前では、Requested Range Not Satisfiable（リクエストしたレンジは範囲外にある）と定められていた。'
    },
    {
      number: 417,
      status: 'Expectation Failed',
      details: 'The server cannot meet the requirements of the Expect request-header field.',
      details_jp: 'Expectヘッダによる拡張が失敗。その拡張はレスポンスできない。またはプロキシサーバは、' +
                  '次に到達するサーバがレスポンスできないと判断している。具体例として、Expect:ヘッダに100-continue' +
                  '以外の変なものを入れた場合や、そもそもサーバが100 Continueを扱えない場合に返す。'
    },
    {
      number: 418,
      status: 'I\'m a teapot (RFC 2324)',
      details: 'This code was defined in 1998 as one of the traditional IETF April Fools\' jokes, in RFC 2324, ' +
                'Hyper Text Coffee Pot Control Protocol, and is not expected to be implemented by actual HTTP servers. ' +
                'The RFC specifies this code should be returned by teapots requested to brew coffee. This HTTP status is ' +
                'used as an easter egg in some websites, including Google.com.',
      details_jp: '私はティーポット。HTCPCP/1.0の拡張ステータスコード。ティーポットにコーヒーを淹れさせようとして、' +
                  '拒否された場合に返すとされる、ジョークのコードである。'
    },
    {
      number: 421,
      status: 'Misdirected Request (RFC 7540)',
      details: 'The request was directed at a server that is not able to produce a response (for example because ' +
                'a connection reuse).',
      details_jp: '誤ったリクエスト。'
    },
    {
      number: 422,
      status: 'Unprocessable Entity (WebDAV; RFC 4918)',
      details: 'The request was well-formed but was unable to be followed due to semantic errors.',
      details_jp: '処理できないエンティティ。WebDAVの拡張ステータスコード。'
    },
    {
      number: 423,
      status: 'Locked (WebDav; RFC 4918)',
      details: 'The resource that is being accessed is locked.',
      details_jp: 'ロックされている。WebDAVの拡張ステータスコード。リクエストしたリソースがロックされている場合に返す。'
    },
    {
      number: 424,
      status: 'Failed Dependency (WebDAV; RFC 4918)',
      details: 'The request failed due to failure of a previous request (e.g., a PROPATCH).',
      details_jp: '依存関係で失敗。WebDAVの拡張ステータスコード。'
    },
    {
      number: 426,
      status: 'Upgrade Required',
      details: 'The client should switch to a different protocal such as TLS/1.0, given in the Upgrade header field.',
      details_jp: 'アップグレード要求。Upgrading to TLS Within HTTP/1.1の拡張ステータスコード。'
    },
    {
      number: 428,
      status: 'Precondition Required',
      details: 'The origin server requires the request to be conditional. Intended to prevent "the \'lost update\' ' +
                'problem, where a client GETs a resource\'s state, modifies it, and PUTs it back to the server, when meanwhile ' +
                'a third party has modified the state on the server, leading to a conflict."',
      details_jp: ''
    },
    {
      number: 429,
      status: 'Too Many Requests',
      details: 'The user has sent too many requests in a given amount of time. Intended for use with rate-limiting schemes.',
      details_jp: ''
    },
    {
      number: 431,
      status: 'Request Header Fields Too Large (RFC 6585)',
      details: 'The user has sent too many requests in a given amount of time. Intended for use with rate-limiting schemes.',
      details_jp: ''
    },
    {
      number: 451,
      status: 'Unavailable For Legal Reasons',
      details: 'A server operator has received a legal demand to deny access to a resource or to a set of resources ' +
                'that includes the requested resource. The code 451 was chosen as a reference to the novel Fahrenheit 451.',
      details_jp: '法的理由により利用不可。403 Forbiddenから派生したステータスコード。'
    },


    {
      number: 500,
      status: 'Internal Server Error',
      details: 'A generic error message, given when an unexpected condition was encountered and no more specific ' +
                'message is suitable.',
      details_jp: 'サーバ内部エラー。サーバ内部にエラーが発生した場合に返される。例として、CGIとして動作させているプログラム' +
                  'に文法エラーがあったり、設定に誤りがあった場合などに返される。'
    },
    {
      number: 501,
      status: 'Not Implemented',
      details: 'The server either does not recognize the request method, or it lacks the ability to fulfill the ' +
                'request. Usually this implies future availability (e.g., a new feature of a web-service API).',
      details_jp: '実装されていない。実装されていないメソッドを使用した。例として、WebDAVが実装されていないサーバに' +
                  '対してWebDAVで使用するメソッド（MOVEやCOPY）を使用した場合に返される。'
    },
    {
      number: 502,
      status: 'Bad Gateway',
      details: 'The server was acting as a gateway or proxy and received an invalid response from the upstream server.',
      details_jp: '不正なゲートウェイ。ゲートウェイ・プロキシサーバは不正な要求を受け取り、これを拒否した。'
    },
    {
      number: 503,
      status: 'Service Unavailable',
      details: 'The server is currently unavailable (because it is overloaded or down for maintenance). ' +
                'Generally, this is a temporary state.',
      details_jp: 'サービス利用不可。サービスが一時的に過負荷やメンテナンスで使用不可能である。例として、アクセスが殺到して' +
                  '処理不能に陥った場合に返される。'
    },
    {
      number: 504,
      status: 'Gateway Time-out',
      details: 'The server was acting as a gateway or proxy and did not receive a timely response from ' +
                'the upstream server.',
      details_jp: 'ゲートウェイタイムアウト。ゲートウェイ・プロキシサーバはURIから推測されるサーバからの適切なレスポンスがなく' +
                  'タイムアウトした。'
    },
    {
      number: 505,
      status: 'HTTP Version Not Supported',
      details: 'The server does not support the HTTP protocol version used in the request.',
      details_jp: 'サポートしていないHTTPバージョン。リクエストがサポートされていないHTTPバージョンである場合に返される。'
    },
    {
      number: 506,
      status: 'Variant Also Negotiates (RFC 2295)',
      details: 'Transparent content negotiation for the request results in a circular reference.',
      details_jp: 'Transparent Content Negotiation in HTTPで定義されている拡張ステータスコード。'
    },
    {
      number: 507,
      status: 'Insufficient Storage (WebDAV; RFC 4918)',
      details: 'The server is unable to store the representation needed to complete the request.',
      details_jp: '容量不足。WebDAVの拡張ステータスコード。リクエストを処理するために必要なストレージの容量が足りない場合に返される。'
    },
    {
      number: 508,
      status: 'Loop Detected (WebDAV; RFC 5842)',
      details: 'The server detected an infinite loop while processing the request (sent in lieu of 208 Already Reported).',
      details_jp: 'WebDAVの拡張ステータスコード。'
    },
    {
      number: 510,
      status: 'Not Extended (RFC 2774)',
      details: 'Further extensions to the request are required for the server to fulfill it.',
      details_jp: '拡張できない。An HTTP Extension Frameworkで定義されている拡張ステータスコード。'
    },
    {
      number: 511,
      status: 'Network Authentication Required (RFC 6585)',
      details: 'The client needs to authenticate to gain network access. Intended for use by intercepting proxies ' +
                'used to control access to the network (e.g., "captive portals" used to require agreement to Terms of ' +
                'Service before granting full Internet access via a Wi-Fi hotspot).',
      details_jp: ''
    }
  ]

  # TODO: Add unofficial codes, like 103 Checkpoint
  
  # Add classification to all statuses
  Statuses.each do |s|
    if s[:number] < 200
      s[:classification] = 'Information Response'
    elsif s[:number] >= 200 and s[:number] < 300
      s[:classification] = 'Success'
    elsif s[:number] >= 300 and s[:number] < 400
      s[:classification] = 'Redirection'
    elsif s[:number] >= 400 and s[:number] < 500
      s[:classification] = 'Client Error'
    else
      s[:classification] = 'Server Error'
    end
  end  
end
