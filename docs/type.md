# Ruby の型

## やりたいこと

* Ruby で型を定義する
 * 現状は Class = 型とする
* 型チェックを行う仕組み
* ジェネリックプログラミングや Variant 型(Haskell の Either みたいなの？)の定義
 * C++ の template みたいなのもほしい
* 型によって処理を切り替える装置

## 動作イメージ

#### 型の定義

```ruby
# To type
1.type  # => Fixnum
"".type # => String
String.type # == String
```

```ruby
# Variant type
(String | Fixnum) # => String or Fixnum
(String | Fixnum | Hash) # => String or Fixnum or Hahs
```

```ruby
# Super class type
+Numeric # => Numeric is super class type

# No type
!Numerci # => Not Numeric type
```

##### 型の比較

```ruby
1.type == Fixnum  # => true
1.type == String  # => false
1.type <= Numeric # => true
1.type == Numeric # => false
```

```ruby
# Type1 | Type2 => Variant type
(String | Fixnum) == 1  # true
(String | Fixnum) == "" # true
(String | Fixnum) == {} # false
```


#### 型変数の定義

```ruby
let :name, String
self.name = "" # OK
self.name = 42 # Error
```


```ruby
let :data, String | Numeric # Variant 型
self.data = "" # OK
self.data = 42 # OK
self.data = {} # Error
```


```ruby
let :bool, True | False # Variant 型
self.bool = true  # OK
self.bool = false # OK
self.bool = nil # Error
```


```ruby
class X
  let name: String, age: Numeric
end
x = X.new
x.name = "homu" # OK
x.age = 13 # OK
x.name 13 # Error
```

## 悩み

型同士の比較をどうするか考える

1.type # => Fixnum

1.type ==  Numeric # => Fixnum ==  Numeric
1.type <=  Numeric # => Fixnum <=  Numeric
1.type === Numeric # => Fixnum === Numeric

1.type ==  +Numeric # => Fixnum == Numeric
1.type <=  +Numeric # => Fixnum <= Numeric
1.type === +Numeric # => Fixnum <= Numeric

1.type ==  !Numeric # => Fixnum == Numeric
1.type !=  !Numeric # => Fixnum != Numeric
1.type === !Numeric # => Fixnum != Numeric





class A
	def == rhs
		p "A#== #{rhs.class}"
	end
end

class B
	def == rhs
		p "B#== #{rhs.class}"
	end
end

class A
	prepend(Module.new do
		define_method(:==) do |rhs|
			rhs.class == B ? rhs == self : super(rhs)
		end
	end)
end


class C
	
end

A.new == B.new
A.new == C.new



class A
	def == rhs
		if rhs.respond_to? :callable_equal
			rhs.callable_equal(self)
		else
			p "A#== #{rhs.class}"
		end
	end
end

class B
	def callable_equal rhs
		p "B#== #{rhs.class}"
	end
end

class C
	
end

A.new == B.new
A.new == C.new



class A
	def == rhs
		p "A#== #{rhs.class}"
	end
end

class B
	def == rhs
		p "B#== #{rhs.class}"
	end
end

class A
	prepend(Module.new do
		define_method(:==) do |rhs|
			rhs.class == B ? rhs == self : super(rhs)
		end
	end)
end


class C
	
end

class D
	def == rhs
		p "D#== #{rhs.class}"
	end
end

class A
	prepend(Module.new do
		define_method(:==) do |rhs|
			rhs.class == D ? rhs == self : super(rhs)
		end
	end)
end


A.new == Object.new
A.new == A.new
A.new == B.new
A.new == C.new
A.new == D.new


