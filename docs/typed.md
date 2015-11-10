


```ruby
class X
  let name: String, age: Numeric
end
x = X.new
x.name = "homu" # OK
x.age = 13 # OK
x.name 13 # Error
```



