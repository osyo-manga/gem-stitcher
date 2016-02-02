# iolite

## これは何？

定義する（定義した）メソッドに対して引数のシグネチャを設定するライブラリです。
シグネチャを指定することにより、静的型付け言語のようなメソッドの多重定義を行うことを目的としています、


## 導入

#### install

```shell
$ gem install stitcher
```

#### require

```ruby
require "stitcher"

using Stitcher
```

## 使い方

#### シグネチャの設定

`stitcher` は定義したメソッドか、次に定義するメソッドに対してシグネチャを設定することで使用します。

```ruby
require "stitcher"

# using することで Module クラスに Stitcher の機能が mixin される
using Stitcher


class Counter
	attr_reader :value

	def initialize value
		@value = value
	end
	# 既存のメソッドに対して引数のシグネチャを設定する
	# #initialize メソッドに対して Fixnum クラスのインスタンスのみ受け取るようにする
	stitcher_register :initialize, [Fixnum]

	# stitcher_register を使用することで次に定義するメソッドに対しての
	# シグネチャを設定することもできる
	# stitcher_register の第二引数と stitcher_require の第一引数は同じである
	stitcher_require [Fixnum]
	# add メソッドは Fixnum のインスタンスのみ受け付ける
	def add value
		@value += value
	end

	# また、違うシグネチャを設定することにより複数のメソッドを定義する事ができる
	stitcher_require [String]
	def add str
		@value += str.to_i
	end
end

count = Counter.new 0		# OK
# count = Counter.new ""	# Error: Fixnum クラスのインスタンスではない

count.add 10				# OK
count.add "12"				# OK
# count.add 0.42			# Error
p count.value
# => 22
```

```ruby
using Stitcher
```

まず、`using` を使用して、特定の範囲でのみ Stitcher を使用することを定義します。  
この時に `Module` クラス内に Stitcher の機能が `mixin` され、いくつかのクラス拡張が適用されます。  

```ruby
def initialize value
    @value = value
end
stitcher_register :initialize, [Fixnum]
```

`.stitcher_register` を使用して既存のメソッドに対してシグネチャを設定します。  
この時に設定するシグネチャは各引数に対するリストになります。  
また、各シグネチャと実引数の要素は `#===` を用いて比較が行われ、このメソッドが真を返せばシグネチャにマッチしたと認識されます。 

```ruby
stitcher_require [Fixnum]
def add value
    @value += value
end
```

`.stitcher_require` を使用して、次に定義されるメソッドに対してのシグネチャを設定します。  
設定するシグネチャは `.stitcher_register` と同じです。 

```ruby
stitcher_require [String]
def add str
    @value += str.to_i
end
```

違うシグネチャを設定することで静的型付け言語のような多重定義を行うことができます。  
これにより『引数のクラス』によって簡単に処理を分岐することができます。

#### シグネチャの設定

各引数のシグネチャは `#===` が定義されてるオブジェクトであればなんでも設定する事ができます。  
これは Ruby の `case` 文と似ています。
例えば、`Class` 以外にも `Proc` や `Regexp` などを渡すことができます。

```ruby
class Http
	stitcher_require [/^https?/]
	def post url
		# ...
	end

	stitcher_require [ proc { |hash| (Hash === hash && hash.key?(:url)) } ]
	def post hash
		post hash[:url]
	end
end

http = Http.new
http.post "http://docs.ruby-lang.org/"				# OK
http.post({ url: "http://docs.ruby-lang.org/" })	# OK

http.post "ftp://docs.ruby-lang.org/"				# Error
http.post({ uri: "http://docs.ruby-lang.org/" })	# Error
```

このようにしてより厳密な引数に対する要求を設定することができます。  
また、`Class` や `Proc`、`Regexp` は `&` や `|` で結合することもできます。

```ruby
# Hash であることと Proc の条件を満たすことを要求する
stitcher_require [Hash & proc { |hash| (hash.key?(:url)) } ]
def post hash
    post hash[:url]
end
```

#### 多重定義字に呼び出されるメソッドの優先順位

Stitcehr を利用してメソッドを多重定義した場合に呼び出されるメソッドの優先順位は __下から順に優先順位が高くなります。__  
例えば、次のような定義の場合、

```ruby
require "stitcher"

using Stitcher

class X
	stitcher_require [Fixnum]
	def func value
		"Fixnum"
	end

	stitcher_require [Numeric]
	def func value
		"Numeric"
	end
end
```

あとから定義されている `func(Numeric)` の方が優先順位が高くなり、

```
x = X.new
x.func 10     # Numeric === 10 # => true
```

というような呼び出しの場合は、`Numeric#===` がどちらも真となるため、`func(Fixnum)` ではなくて `func(Numeric)` が呼び出されます。  
これは次のように `Fixnum` にマッチしないようにすることで回避することは可能です。

```ruby
require "stitcher"

using Stitcher

class X
	stitcher_require [Fixnum]
	def func value
		"Fixnum"
	end

	# Numeric であり、Fixnum 以外にマッチする場合のシグネチャ
	stitcher_require [Numeric & !Fixnum]
	def func value
		"Numeric"
	end
end

x = X.new
p x.func 10
# => "Fixnum"
p x.func 0.42
# => "Numeric"
```


